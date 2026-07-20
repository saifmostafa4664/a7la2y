import 'package:a7la2y/core/services/connectivity_service.dart';
import 'package:a7la2y/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:a7la2y/features/auth/data/datasources/firestore_user_datasource.dart';
import 'package:a7la2y/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:a7la2y/features/auth/domain/repositories/auth_repository.dart';
import 'package:a7la2y/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:a7la2y/features/auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Services
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Datasources
  sl.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasource(
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  sl.registerLazySingleton<FirestoreUserDatasource>(
    () => FirestoreUserDatasource(firestore: sl<FirebaseFirestore>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDatasource: sl<FirebaseAuthDatasource>(),
      firestoreDatasource: sl<FirestoreUserDatasource>(),
    ),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepository: sl<AuthRepository>(),
      connectivityService: sl<ConnectivityService>(),
    ),
  );

  sl.registerFactory<PhoneAuthCubit>(
    () => PhoneAuthCubit(
      authRepository: sl<AuthRepository>(),
      connectivityService: sl<ConnectivityService>(),
    ),
  );
}

import 'package:a7la2y/core/errors/auth_error_mapper.dart';
import 'package:a7la2y/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:a7la2y/features/auth/data/datasources/firestore_user_datasource.dart';
import 'package:a7la2y/features/auth/domain/entities/auth_entity.dart';
import 'package:a7la2y/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _authDatasource;
  final FirestoreUserDatasource _firestoreDatasource;

  AuthRepositoryImpl({
    required FirebaseAuthDatasource authDatasource,
    required FirestoreUserDatasource firestoreDatasource,
  })  : _authDatasource = authDatasource,
        _firestoreDatasource = firestoreDatasource;

  @override
  Stream<User?> get authStateChanges => _authDatasource.authStateChanges;

  @override
  User? get currentUser => _authDatasource.currentUser;

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final userCredential = await _authDatasource.signInWithGoogle();
      final firebaseUser = userCredential.user!;
      return getOrCreateFirestoreUser(firebaseUser: firebaseUser);
    } on AuthCancelledException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (e) {
      if (e.toString().contains('sign_in_canceled') ||
          e.toString().contains('canceled') ||
          e.toString().contains('إلغاء')) {
        throw AuthCancelledException('تم إلغاء تسجيل الدخول بجوجل');
      }
      throw Exception(AuthErrorMapper.mapFirebaseError('unknown'));
    }
  }

  @override
  Future<AppUser> signInWithApple() async {
    try {
      final userCredential = await _authDatasource.signInWithApple();
      final firebaseUser = userCredential.user!;
      return getOrCreateFirestoreUser(firebaseUser: firebaseUser);
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (e) {
      if (e.toString().contains('AuthorizationErrorCode.canceled') ||
          e.toString().contains('canceled') ||
          e.toString().contains('إلغاء')) {
        throw AuthCancelledException('تم إلغاء تسجيل الدخول بـ Apple');
      }
      throw Exception(AuthErrorMapper.mapFirebaseError('unknown'));
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(PhoneAuthCredential credential) onAutoVerify,
    required void Function(String message) onError,
    int? forceResendingToken,
  }) async {
    final normalizedPhone = _normalizeEgyptianPhone(phoneNumber);

    await _authDatasource.verifyPhoneNumber(
      phoneNumber: normalizedPhone,
      onCodeSent: onCodeSent,
      onAutoVerificationCompleted: onAutoVerify,
      onVerificationFailed: (e) {
        onError(AuthErrorMapper.mapFirebaseError(e.code));
      },
      onCodeAutoRetrievalTimeout: (_) {},
      forceResendingToken: forceResendingToken,
    );
  }

  @override
  Future<AppUser> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final userCredential = await _authDatasource.signInWithSmsCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final firebaseUser = userCredential.user!;
      return getOrCreateFirestoreUser(
        firebaseUser: firebaseUser,
        phone: firebaseUser.phoneNumber,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (e) {
      throw Exception(AuthErrorMapper.mapFirebaseError('unknown'));
    }
  }

  @override
  Future<AppUser?> getFirestoreUser(String uid) async {
    return _firestoreDatasource.getUser(uid);
  }

  @override
  Future<AppUser> getOrCreateFirestoreUser({
    required User firebaseUser,
    String? role,
    String? displayName,
    String? phone,
  }) async {
    return _firestoreDatasource.getOrCreateUser(
      uid: firebaseUser.uid,
      phone: phone ?? firebaseUser.phoneNumber,
      email: firebaseUser.email,
      displayName: displayName ?? firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      role: role ?? 'client',
    );
  }

  @override
  Future<void> updateFirestoreUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestoreDatasource.updateUser(uid, data);
  }

  @override
  Future<void> signOut() async {
    await _authDatasource.signOut();
  }

  String _normalizeEgyptianPhone(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleaned.startsWith('01') && cleaned.length == 11) {
      return '+2$cleaned';
    }

    if (cleaned.startsWith('201') && cleaned.length == 12) {
      return '+$cleaned';
    }

    if (cleaned.startsWith('+2') && cleaned.length == 13) {
      return cleaned;
    }

    return cleaned.startsWith('+') ? cleaned : '+$cleaned';
  }
}

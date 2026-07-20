import 'package:a7la2y/core/services/connectivity_service.dart';
import 'package:a7la2y/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:a7la2y/features/auth/domain/repositories/auth_repository.dart';
import 'package:a7la2y/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final ConnectivityService _connectivityService;
  bool _isProcessing = false;

  AuthCubit({
    required AuthRepository authRepository,
    required ConnectivityService connectivityService,
  })  : _authRepository = authRepository,
        _connectivityService = connectivityService,
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading(method: 'session'));

    final firebaseUser = _authRepository.currentUser;
    if (firebaseUser == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    try {
      final appUser = await _authRepository.getFirestoreUser(firebaseUser.uid);
      if (appUser != null) {
        emit(AuthAuthenticated(user: appUser));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signInWithGoogle() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      if (!await _connectivityService.hasConnection) {
        emit(const AuthError(
            message: 'لا يوجد اتصال بالإنترنت. تحقق من اتصالك.'));
        return;
      }

      emit(const AuthLoading(method: 'google'));
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user: user));
    } on AuthCancelledException {
      emit(const AuthInitial());
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message.contains('إلغاء')) {
        emit(const AuthInitial());
      } else {
        emit(AuthError(message: message));
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> signInWithApple() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      if (!await _connectivityService.hasConnection) {
        emit(const AuthError(
            message: 'لا يوجد اتصال بالإنترنت. تحقق من اتصالك.'));
        return;
      }

      emit(const AuthLoading(method: 'apple'));
      final user = await _authRepository.signInWithApple();
      emit(AuthAuthenticated(user: user));
    } on AuthCancelledException {
      emit(const AuthInitial());
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message.contains('إلغاء')) {
        emit(const AuthInitial());
      } else {
        emit(AuthError(message: message));
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (_) {
      emit(const AuthError(message: 'فشل تسجيل الخروج. حاول مرة أخرى.'));
    }
  }

  void reset() {
    _isProcessing = false;
    emit(const AuthInitial());
  }
}

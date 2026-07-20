import 'dart:async';

import 'package:a7la2y/core/errors/auth_error_mapper.dart';
import 'package:a7la2y/core/services/connectivity_service.dart';
import 'package:a7la2y/features/auth/domain/repositories/auth_repository.dart';
import 'package:a7la2y/features/auth/presentation/cubit/phone_auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final AuthRepository _authRepository;
  final ConnectivityService _connectivityService;

  String? _verificationId;
  int? _resendToken;
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  bool _isProcessing = false;

  PhoneAuthCubit({
    required AuthRepository authRepository,
    required ConnectivityService connectivityService,
  })  : _authRepository = authRepository,
        _connectivityService = connectivityService,
        super(const PhoneAuthInitial());

  String? get verificationId => _verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      if (!await _connectivityService.hasConnection) {
        emit(const PhoneAuthError(
            message: 'لا يوجد اتصال بالإنترنت. تحقق من اتصالك.'));
        _isProcessing = false;
        return;
      }

      final validationError = _validateEgyptianPhone(phoneNumber);
      if (validationError != null) {
        emit(PhoneAuthError(message: validationError));
        _isProcessing = false;
        return;
      }

      emit(const PhoneAuthLoading());

      await _authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _startCooldown();
          emit(PhoneAuthCodeSent(
            verificationId: verificationId,
            resendToken: resendToken,
          ));
          _isProcessing = false;
        },
        onAutoVerify: (credential) async {
          try {
            final userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            final firebaseUser = userCredential.user!;
            final appUser = await _authRepository.getOrCreateFirestoreUser(
              firebaseUser: firebaseUser,
              phone: firebaseUser.phoneNumber,
            );
            emit(PhoneAuthAutoVerified(user: appUser));
          } catch (e) {
            emit(PhoneAuthError(
                message: AuthErrorMapper.mapFirebaseError('unknown')));
          }
          _isProcessing = false;
        },
        onError: (message) {
          emit(PhoneAuthError(message: message));
          _isProcessing = false;
        },
      );
    } catch (e) {
      emit(PhoneAuthError(
          message: AuthErrorMapper.mapFirebaseError('unknown')));
      _isProcessing = false;
    }
  }

  Future<void> resendCode(String phoneNumber) async {
    if (_cooldownSeconds > 0) return;
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      if (!await _connectivityService.hasConnection) {
        emit(const PhoneAuthError(
            message: 'لا يوجد اتصال بالإنترنت. تحقق من اتصالك.'));
        _isProcessing = false;
        return;
      }

      emit(const PhoneAuthLoading());

      await _authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: _resendToken,
        onCodeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _startCooldown();
          emit(PhoneAuthCodeSent(
            verificationId: verificationId,
            resendToken: resendToken,
          ));
          _isProcessing = false;
        },
        onAutoVerify: (_) {},
        onError: (message) {
          emit(PhoneAuthError(message: message));
          _isProcessing = false;
        },
      );
    } catch (e) {
      emit(PhoneAuthError(
          message: AuthErrorMapper.mapFirebaseError('unknown')));
      _isProcessing = false;
    }
  }

  Future<void> verifySmsCode(String smsCode) async {
    if (_verificationId == null) {
      emit(const PhoneAuthError(message: 'لم يتم إرسال رمز التحقق بعد.'));
      return;
    }
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      emit(const PhoneAuthVerifying());

      final user = await _authRepository.verifySmsCode(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      emit(PhoneAuthSuccess(user: user));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(PhoneAuthError(message: message));
    } finally {
      _isProcessing = false;
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _cooldownSeconds = 60;

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _cooldownSeconds--;
      if (_cooldownSeconds <= 0) {
        timer.cancel();
        _cooldownSeconds = 0;
      }
      if (_verificationId != null) {
        emit(PhoneAuthResendCooldown(
          verificationId: _verificationId!,
          resendToken: _resendToken,
          secondsRemaining: _cooldownSeconds,
        ));
      }
    });
  }

  String? _validateEgyptianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleaned.isEmpty) {
      return 'أدخل رقم الهاتف.';
    }

    final localPattern = RegExp(r'^01[0125]\d{8}$');
    final intlPattern = RegExp(r'^\+?201[0125]\d{8}$');

    if (!localPattern.hasMatch(cleaned) && !intlPattern.hasMatch(cleaned)) {
      return 'رقم هاتف مصري غير صالح. يجب أن يبدأ بـ 01.';
    }

    return null;
  }

  void reset() {
    _cooldownTimer?.cancel();
    _cooldownSeconds = 0;
    _verificationId = null;
    _resendToken = null;
    _isProcessing = false;
    emit(const PhoneAuthInitial());
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}

import 'package:a7la2y/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {
  const PhoneAuthInitial();
}

class PhoneAuthLoading extends PhoneAuthState {
  const PhoneAuthLoading();
}

class PhoneAuthCodeSent extends PhoneAuthState {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthCodeSent({
    required this.verificationId,
    this.resendToken,
  });

  @override
  List<Object?> get props => [verificationId, resendToken];
}

class PhoneAuthAutoVerified extends PhoneAuthState {
  final AppUser user;

  const PhoneAuthAutoVerified({required this.user});

  @override
  List<Object?> get props => [user];
}

class PhoneAuthVerifying extends PhoneAuthState {
  const PhoneAuthVerifying();
}

class PhoneAuthSuccess extends PhoneAuthState {
  final AppUser user;

  const PhoneAuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class PhoneAuthError extends PhoneAuthState {
  final String message;

  const PhoneAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PhoneAuthResendCooldown extends PhoneAuthState {
  final String verificationId;
  final int? resendToken;
  final int secondsRemaining;

  const PhoneAuthResendCooldown({
    required this.verificationId,
    this.resendToken,
    required this.secondsRemaining,
  });

  @override
  List<Object?> get props => [verificationId, resendToken, secondsRemaining];
}

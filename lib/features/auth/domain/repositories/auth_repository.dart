import 'package:a7la2y/features/auth/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<AppUser> signInWithGoogle();

  Future<AppUser> signInWithApple();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(PhoneAuthCredential credential) onAutoVerify,
    required void Function(String message) onError,
    int? forceResendingToken,
  });

  Future<AppUser> verifySmsCode({
    required String verificationId,
    required String smsCode,
  });

  Future<AppUser?> getFirestoreUser(String uid);

  Future<AppUser> getOrCreateFirestoreUser({
    required User firebaseUser,
    String? role,
    String? displayName,
    String? phone,
  });

  Future<void> updateFirestoreUser({
    required String uid,
    required Map<String, dynamic> data,
  });

  Future<void> signOut();
}

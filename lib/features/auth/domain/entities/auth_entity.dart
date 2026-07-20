import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String? phone;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String role;
  final bool isProfileCompleted;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const AppUser({
    required this.uid,
    this.phone,
    this.email,
    this.displayName,
    this.photoUrl,
    this.role = 'client',
    this.isProfileCompleted = false,
    required this.createdAt,
    required this.lastLoginAt,
  });

  AppUser copyWith({
    String? uid,
    String? phone,
    String? email,
    String? displayName,
    String? photoUrl,
    String? role,
    bool? isProfileCompleted,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        phone,
        email,
        displayName,
        photoUrl,
        role,
        isProfileCompleted,
        createdAt,
        lastLoginAt,
      ];
}

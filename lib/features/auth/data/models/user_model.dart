import 'package:a7la2y/features/auth/domain/entities/auth_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    super.phone,
    super.email,
    super.displayName,
    super.photoUrl,
    super.role,
    super.isProfileCompleted,
    required super.createdAt,
    required super.lastLoginAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      role: (map['role'] as String?) ?? 'client',
      isProfileCompleted: (map['isProfileCompleted'] as bool?) ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt:
          (map['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'isProfileCompleted': isProfileCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }

  factory UserModel.fromEntity(AppUser entity) {
    return UserModel(
      uid: entity.uid,
      phone: entity.phone,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      role: entity.role,
      isProfileCompleted: entity.isProfileCompleted,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }
}

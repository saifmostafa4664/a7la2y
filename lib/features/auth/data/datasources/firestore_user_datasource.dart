import 'package:a7la2y/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDatasource {
  final FirebaseFirestore _firestore;

  static const String _collection = 'users';

  FirestoreUserDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(_collection).doc(uid);

  Future<UserModel?> getUser(String uid) async {
    final doc = await _userDoc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<UserModel> createUser(UserModel user) async {
    await _userDoc(user.uid).set(user.toMap());
    return user;
  }

  Future<void> updateLastLogin(String uid) async {
    await _userDoc(uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _userDoc(uid).update(data);
  }

  Future<UserModel> getOrCreateUser({
    required String uid,
    String? phone,
    String? email,
    String? displayName,
    String? photoUrl,
    String role = 'client',
  }) async {
    final existingUser = await getUser(uid);

    if (existingUser != null) {
      await updateLastLogin(uid);
      return UserModel(
        uid: existingUser.uid,
        phone: existingUser.phone,
        email: existingUser.email,
        displayName: existingUser.displayName,
        photoUrl: existingUser.photoUrl,
        role: existingUser.role,
        isProfileCompleted: existingUser.isProfileCompleted,
        createdAt: existingUser.createdAt,
        lastLoginAt: DateTime.now(),
      );
    }

    final now = DateTime.now();
    final newUser = UserModel(
      uid: uid,
      phone: phone,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      role: role,
      isProfileCompleted: false,
      createdAt: now,
      lastLoginAt: now,
    );

    return createUser(newUser);
  }
}

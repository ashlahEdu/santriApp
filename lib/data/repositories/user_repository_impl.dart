// Lokasi: lib/data/repositories/user_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/app_user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<void> saveUserData(
    String uid,
    String email,
    String mobileNumber,
    UserRole role, {
    List<String> assignedSantriIds = const [],
  }) {
    return _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role.toFirestoreString(),
      'assignedSantriIds': assignedSantriIds,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<AppUser?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUserModel.fromFirestore(doc);
  }

  @override
  Stream<AppUser?> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUserModel.fromFirestore(doc) : null);
  }

  @override
  Stream<List<AppUser>> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppUserModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> updateUserRole(String uid, UserRole newRole) {
    return _firestore.collection('users').doc(uid).update({
      'role': newRole.toFirestoreString(),
    });
  }

  @override
  Future<void> assignSantriToUser(String userUid, List<String> santriIds) {
    return _firestore.collection('users').doc(userUid).update({
      'assignedSantriIds': santriIds,
    });
  }

  @override
  Future<void> deleteUser(String uid) {
    return _firestore.collection('users').doc(uid).delete();
  }
}

// Lokasi: lib/data/repositories/user_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<void> saveUserData(
      String uid, String email, String mobileNumber) {
    return _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'mobileNumber': mobileNumber,
      'createdAt': Timestamp.now(),
    });
  }
}
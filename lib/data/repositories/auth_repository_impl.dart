// Lokasi: lib/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  // Pastikan method ini mengembalikan UserCredential
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) {
    // Tambahkan 'return' di sini
    return _firebaseAuth.createUserWithEmailAndPassword( 
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
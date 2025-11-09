// Lokasi: lib/domain/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithEmailAndPassword(String email, String password);
  
  // Ubah baris ini dari Future<void> menjadi Future<UserCredential>
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password); 
  
  Future<void> signOut();
  User? get currentUser;
}
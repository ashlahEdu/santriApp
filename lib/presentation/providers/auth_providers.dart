// Lokasi: lib/presentation/providers/auth_providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// 1. Provider untuk instance FirebaseAuth (agar bisa diakses global)
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// 2. Provider untuk AuthRepository
// Ini akan otomatis membuatkan AuthRepositoryImpl dengan instance FirebaseAuth
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(firebaseAuthProvider));
});

// 3. Stream Provider untuk memantau status login
// Ini adalah PENGGANTI AuthGate kita yang lama
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
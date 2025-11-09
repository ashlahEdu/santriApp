// Lokasi: lib/presentation/providers/user_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/santri_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/santri.dart'; // Impor entitas Santri
import '../../domain/repositories/santri_repository.dart'; // Impor kontrak Santri
import '../../domain/repositories/user_repository.dart';

// 1. Provider untuk instance FirebaseFirestore (Sudah ada)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// 2. Provider untuk UserRepository (Sudah ada)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(firebaseFirestoreProvider));
});


// --- TAMBAHKAN KODE BARU DI BAWAH INI ---

// 3. Provider untuk SantriRepository
final santriRepositoryProvider = Provider<SantriRepository>((ref) {
  return SantriRepositoryImpl(ref.watch(firebaseFirestoreProvider));
});

// 4. StreamProvider untuk mendapatkan SEMUA santri secara real-time
final allSantriStreamProvider = StreamProvider<List<Santri>>((ref) {
  return ref.watch(santriRepositoryProvider).getAllSantri();
});
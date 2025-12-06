// Lokasi: lib/presentation/providers/user_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/santri_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/santri.dart'; // Impor entitas Santri
import '../../domain/repositories/santri_repository.dart'; // Impor kontrak Santri
import '../../domain/repositories/user_repository.dart';
import '/data/repositories/penilaian_repository_impl.dart';
import '/domain/entities/penilaian_tahfidz.dart';

import '../../domain/entities/penilaian_mapel.dart';
import '../../domain/entities/penilaian_akhlak.dart';
import '../../domain/entities/kehadiran.dart';

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

// Provider Repository
final penilaianRepositoryProvider = Provider<PenilaianRepository>((ref) {
  return PenilaianRepositoryImpl(ref.watch(firebaseFirestoreProvider));
});

// Stream Provider untuk mengambil history tahfidz (butuh ID Santri)
// Kita gunakan .family karena butuh parameter santriId
final tahfidzHistoryProvider =
    StreamProvider.family<List<PenilaianTahfidz>, String>((ref, santriId) {
      return ref.watch(penilaianRepositoryProvider).getTahfidzHistory(santriId);
    });

final mapelHistoryProvider =
    StreamProvider.family<List<PenilaianMapel>, String>((ref, santriId) {
      return ref
          .watch(penilaianRepositoryProvider)
          .getMapelHistory(santriId, '');
    });

// 4. Provider Riwayat Akhlak
final akhlakHistoryProvider =
    StreamProvider.family<List<PenilaianAkhlak>, String>((ref, santriId) {
      return ref.watch(penilaianRepositoryProvider).getAkhlakHistory(santriId);
    });

// 5. Provider Riwayat Kehadiran
final kehadiranHistoryProvider = StreamProvider.family<List<Kehadiran>, String>(
  (ref, santriId) {
    return ref.watch(penilaianRepositoryProvider).getKehadiranHistory(santriId);
  },
);

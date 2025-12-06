// Lokasi: lib/presentation/providers/rapor_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/rapor_data.dart';
import '../../presentation/providers/user_providers.dart';

// Provider ini akan menghitung Rapor secara otomatis setiap kali data nilai berubah
final raporProvider = Provider.family<AsyncValue<RaporData>, String>((
  ref,
  santriId,
) {
  // 1. Ambil semua data riwayat (watch agar real-time)
  final tahfidzAsync = ref.watch(tahfidzHistoryProvider(santriId));
  final mapelAsync = ref.watch(mapelHistoryProvider(santriId));
  final akhlakAsync = ref.watch(akhlakHistoryProvider(santriId));
  final kehadiranAsync = ref.watch(kehadiranHistoryProvider(santriId));

  // Jika salah satu masih loading/error, kembalikan statusnya
  if (tahfidzAsync.isLoading ||
      mapelAsync.isLoading ||
      akhlakAsync.isLoading ||
      kehadiranAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (tahfidzAsync.hasError ||
      mapelAsync.hasError ||
      akhlakAsync.hasError ||
      kehadiranAsync.hasError) {
    return const AsyncValue.error('Gagal memuat data nilai', StackTrace.empty);
  }

  // Ambil data list (atau list kosong jika null)
  final tahfidzList = tahfidzAsync.value ?? [];
  final mapelList = mapelAsync.value ?? [];
  final akhlakList = akhlakAsync.value ?? [];
  final kehadiranList = kehadiranAsync.value ?? [];

  // --- LOGIKA PERHITUNGAN ---

  // 1. TAHFIDZ (Bobot 30%)
  // Rumus per item: 0.5 * Capaian + 0.5 * Tajwid
  // Capaian = (ayat / target) * 100. Kita asumsikan target mingguan = 50 ayat (sesuai contoh soal)
  double totalScoreTahfidz = 0;
  if (tahfidzList.isNotEmpty) {
    for (var item in tahfidzList) {
      double capaian = (item.ayat / 50) * 100;
      if (capaian > 100) capaian = 100; // Maksimal 100
      double skorItem = (0.5 * capaian) + (0.5 * item.nilaiTajwid);
      totalScoreTahfidz += skorItem;
    }
    totalScoreTahfidz /= tahfidzList.length; // Rata-rata
  }

  // 2. MAPEL (Fiqh & B. Arab) (Bobot masing-masing 20%)
  // Rumus per item: 0.4 * Formatif + 0.6 * Sumatif
  double scoreFiqh = 0;
  double scoreArab = 0;
  int countFiqh = 0;
  int countArab = 0;

  for (var item in mapelList) {
    double skorItem = (0.4 * item.nilaiFormatif) + (0.6 * item.nilaiSumatif);
    if (item.mataPelajaran == 'Fiqh') {
      scoreFiqh += skorItem;
      countFiqh++;
    } else if (item.mataPelajaran == 'Bahasa Arab') {
      scoreArab += skorItem;
      countArab++;
    }
  }
  if (countFiqh > 0) scoreFiqh /= countFiqh;
  if (countArab > 0) scoreArab /= countArab;

  // 3. AKHLAK (Bobot 20%)
  // Nilai sudah dihitung di model (0-100)
  double scoreAkhlak = 0;
  if (akhlakList.isNotEmpty) {
    for (var item in akhlakList) {
      scoreAkhlak += item.nilaiTotal;
    }
    scoreAkhlak /= akhlakList.length;
  }

  // 4. KEHADIRAN (Bobot 10%)
  // Rumus: (Jumlah Hadir / Total Pertemuan) * 100
  double scoreKehadiran = 0;
  if (kehadiranList.isNotEmpty) {
    int jumlahHadir = kehadiranList.where((k) => k.status == 'H').length;
    scoreKehadiran = (jumlahHadir / kehadiranList.length) * 100;
  } else {
    scoreKehadiran =
        100; // Default jika belum ada absen (anggap hadir semua/bonus)
  }

  // 5. NILAI AKHIR & PREDIKAT
  double nilaiAkhir =
      (0.30 * totalScoreTahfidz) +
      (0.20 * scoreFiqh) +
      (0.20 * scoreArab) +
      (0.20 * scoreAkhlak) +
      (0.10 * scoreKehadiran);

  String predikat = 'D';
  if (nilaiAkhir >= 85)
    predikat = 'A';
  else if (nilaiAkhir >= 75)
    predikat = 'B';
  else if (nilaiAkhir >= 65)
    predikat = 'C';

  // Return data rapor
  return AsyncValue.data(
    RaporData(
      nilaiTahfidz: totalScoreTahfidz,
      nilaiFiqh: scoreFiqh,
      nilaiArab: scoreArab,
      nilaiAkhlak: scoreAkhlak,
      nilaiKehadiran: scoreKehadiran,
      nilaiAkhir: nilaiAkhir,
      predikat: predikat,
    ),
  );
});

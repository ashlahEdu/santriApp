// Lokasi: lib/domain/entities/penilaian_tahfidz.dart

class PenilaianTahfidz {
  final String id;
  final String santriId;
  final String surah;
  final int ayat;
  final int nilaiTajwid; // Rentang 0-100
  final DateTime tanggal;

  PenilaianTahfidz({
    required this.id,
    required this.santriId,
    required this.surah,
    required this.ayat,
    required this.nilaiTajwid,
    required this.tanggal,
  });
}
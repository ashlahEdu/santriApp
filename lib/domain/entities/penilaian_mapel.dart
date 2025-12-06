// Lokasi: lib/domain/entities/penilaian_mapel.dart

class PenilaianMapel {
  final String id;
  final String santriId;
  final String mataPelajaran; // Contoh: "Fiqh" atau "Bahasa Arab"
  final int nilaiFormatif; // 0-100
  final int nilaiSumatif;  // 0-100
  final DateTime tanggal;

  PenilaianMapel({
    required this.id,
    required this.santriId,
    required this.mataPelajaran,
    required this.nilaiFormatif,
    required this.nilaiSumatif,
    required this.tanggal,
  });
}
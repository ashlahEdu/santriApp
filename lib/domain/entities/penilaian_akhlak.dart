// Lokasi: lib/domain/entities/penilaian_akhlak.dart

class PenilaianAkhlak {
  final String id;
  final String santriId;
  final int disiplin; // 1-4
  final int adab;     // 1-4
  final int kebersihan; // 1-4
  final int kerjasama;  // 1-4
  final String catatan;
  final DateTime tanggal;

  PenilaianAkhlak({
    required this.id,
    required this.santriId,
    required this.disiplin,
    required this.adab,
    required this.kebersihan,
    required this.kerjasama,
    required this.catatan,
    required this.tanggal,
  });

  // Helper untuk menghitung rata-rata konversi ke 0-100
  int get nilaiTotal {
    double avg = (disiplin + adab + kebersihan + kerjasama) / 4.0;
    return (avg / 4 * 100).round();
  }
}
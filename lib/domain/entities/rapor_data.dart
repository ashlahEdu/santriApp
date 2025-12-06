// Lokasi: lib/domain/entities/rapor_data.dart

class RaporData {
  final double nilaiTahfidz;
  final double nilaiFiqh;
  final double nilaiArab;
  final double nilaiAkhlak;
  final double nilaiKehadiran;
  final double nilaiAkhir;
  final String predikat;

  RaporData({
    required this.nilaiTahfidz,
    required this.nilaiFiqh,
    required this.nilaiArab,
    required this.nilaiAkhlak,
    required this.nilaiKehadiran,
    required this.nilaiAkhir,
    required this.predikat,
  });

  // Helper untuk membuat data kosong (jika belum ada nilai)
  factory RaporData.empty() {
    return RaporData(
      nilaiTahfidz: 0,
      nilaiFiqh: 0,
      nilaiArab: 0,
      nilaiAkhlak: 0,
      nilaiKehadiran: 0,
      nilaiAkhir: 0,
      predikat: '-',
    );
  }
}
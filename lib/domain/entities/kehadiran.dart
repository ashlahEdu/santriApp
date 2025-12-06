// Lokasi: lib/domain/entities/kehadiran.dart

class Kehadiran {
  final String id;
  final String santriId;
  final String status; // "H", "S", "I", "A"
  final DateTime tanggal;

  Kehadiran({
    required this.id,
    required this.santriId,
    required this.status,
    required this.tanggal,
  });
}
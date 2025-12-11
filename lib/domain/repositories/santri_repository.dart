// Lokasi: lib/domain/repositories/santri_repository.dart
import '../entities/santri.dart';

abstract class SantriRepository {
  // Create
  Future<void> createSantri(Santri santri);

  // Read (mendapatkan semua santri)
  Stream<List<Santri>> getAllSantri();

  // Read (mendapatkan santri berdasarkan list ID)
  Stream<List<Santri>> getSantriByIds(List<String> ids);

  // Read (mendapatkan satu santri)
  Future<Santri?> getSantriById(String id);

  // Update
  Future<void> updateSantri(Santri santri);

  // Delete
  Future<void> deleteSantri(String id);
}

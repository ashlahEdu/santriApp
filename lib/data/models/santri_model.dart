// Lokasi: lib/data/models/santri_model.dart
import '../../domain/entities/santri.dart';

// Model ini 'extends' Entitas.
// Ini adalah implementasi detail dari Santri,
// khusus untuk bagaimana data disimpan di Firebase.
class SantriModel extends Santri {
  SantriModel({
    required super.id,
    required super.nis,
    required super.nama,
    required super.kamar,
    required super.angkatan,
  });

  // Factory untuk membuat SantriModel dari data JSON (Map) Firestore
  factory SantriModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return SantriModel(
      id: documentId,
      nis: data['nis'] ?? '',
      nama: data['nama'] ?? '',
      kamar: data['kamar'] ?? '',
      angkatan: data['angkatan'] ?? 0,
    );
  }

  // Method untuk mengubah SantriModel menjadi JSON (Map) untuk disimpan
  Map<String, dynamic> toFirestore() {
    return {
      'nis': nis,
      'nama': nama,
      'kamar': kamar,
      'angkatan': angkatan,
    };
  }
}
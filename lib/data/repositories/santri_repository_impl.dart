// Lokasi: lib/data/repositories/santri_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/santri_model.dart';
import '../../domain/entities/santri.dart';
import '../../domain/repositories/santri_repository.dart';

class SantriRepositoryImpl implements SantriRepository {
  final FirebaseFirestore _firestore;
  // Kita buat referensi ke koleksi 'santri' agar mudah
  late final CollectionReference _santriCollection;

  SantriRepositoryImpl(this._firestore) {
    _santriCollection = _firestore.collection('santri');
  }

  @override
  Future<void> createSantri(Santri santri) {
    // Kita ubah entitas Santri menjadi SantriModel untuk disimpan
    final santriModel = SantriModel(
      id: santri.id, // Id akan dibuat otomatis oleh Firestore jika kita pakai .add()
      nis: santri.nis,
      nama: santri.nama,
      kamar: santri.kamar,
      angkatan: santri.angkatan,
    );
    // .add() akan membuat dokumen dengan ID unik baru
    return _santriCollection.add(santriModel.toFirestore());
  }

  @override
  Stream<List<Santri>> getAllSantri() {
    // .snapshots() adalah stream yang otomatis update
    return _santriCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Ubah setiap dokumen dari Firestore menjadi SantriModel
        return SantriModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  @override
  Future<Santri?> getSantriById(String id) async {
    final doc = await _santriCollection.doc(id).get();
    if (doc.exists) {
      return SantriModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }
    return null;
  }

  @override
  Future<void> updateSantri(Santri santri) {
    final santriModel = SantriModel(
      id: santri.id,
      nis: santri.nis,
      nama: santri.nama,
      kamar: santri.kamar,
      angkatan: santri.angkatan,
    );
    // .doc(santri.id) menargetkan dokumen spesifik untuk di-update
    return _santriCollection.doc(santri.id).update(santriModel.toFirestore());
  }

  @override
  Future<void> deleteSantri(String id) {
    return _santriCollection.doc(id).delete();
  }
}
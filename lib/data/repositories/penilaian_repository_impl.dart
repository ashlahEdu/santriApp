// Lokasi: lib/data/repositories/penilaian_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/penilaian_tahfidz.dart';
import '../models/penilaian_tahfidz_model.dart';
import '../../../domain/entities/penilaian_mapel.dart'; // Tambahkan import
import '../models/penilaian_mapel_model.dart';

import '../../../domain/entities/penilaian_akhlak.dart';
import '../models/penilaian_akhlak_model.dart';
import '../../../domain/entities/kehadiran.dart';
import '../models/kehadiran_model.dart';

// KONTRAK (Interface)
abstract class PenilaianRepository {
  Future<void> addTahfidz(PenilaianTahfidz penilaian);
  Stream<List<PenilaianTahfidz>> getTahfidzHistory(String santriId);

  Future<void> addMapel(PenilaianMapel penilaian);
  Stream<List<PenilaianMapel>> getMapelHistory(
    String santriId,
    String mataPelajaran,
  );

  Future<void> addAkhlak(PenilaianAkhlak penilaian);
  Stream<List<PenilaianAkhlak>> getAkhlakHistory(String santriId);

  Future<void> addKehadiran(Kehadiran kehadiran);
  Stream<List<Kehadiran>> getKehadiranHistory(String santriId);
}

// IMPLEMENTASI
class PenilaianRepositoryImpl implements PenilaianRepository {
  final FirebaseFirestore _firestore;

  PenilaianRepositoryImpl(this._firestore);

  @override
  Future<void> addTahfidz(PenilaianTahfidz penilaian) {
    final model = PenilaianTahfidzModel(
      id: '', // ID otomatis dari Firestore
      santriId: penilaian.santriId,
      surah: penilaian.surah,
      ayat: penilaian.ayat,
      nilaiTajwid: penilaian.nilaiTajwid,
      tanggal: penilaian.tanggal,
    );

    // Simpan di sub-collection agar rapi: santri/{id}/tahfidz/{id_nilai}
    return _firestore
        .collection('santri')
        .doc(penilaian.santriId)
        .collection('tahfidz')
        .add(model.toFirestore());
  }

  @override
  Stream<List<PenilaianTahfidz>> getTahfidzHistory(String santriId) {
    return _firestore
        .collection('santri')
        .doc(santriId)
        .collection('tahfidz')
        .orderBy('tanggal', descending: true) // Urutkan dari yang terbaru
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PenilaianTahfidzModel.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }

  @override
  Future<void> addMapel(PenilaianMapel penilaian) {
    final model = PenilaianMapelModel(
      id: '',
      santriId: penilaian.santriId,
      mataPelajaran: penilaian.mataPelajaran,
      nilaiFormatif: penilaian.nilaiFormatif,
      nilaiSumatif: penilaian.nilaiSumatif,
      tanggal: penilaian.tanggal,
    );

    // Simpan di sub-collection: santri/{id}/mapel/{id_nilai}
    return _firestore
        .collection('santri')
        .doc(penilaian.santriId)
        .collection('mapel')
        .add(model.toFirestore());
  }

  @override
  Stream<List<PenilaianMapel>> getMapelHistory(
    String santriId,
    String mataPelajaran,
  ) {
    var query = _firestore
        .collection('santri')
        .doc(santriId)
        .collection('mapel')
        .orderBy('tanggal', descending: true);

    // Filter berdasarkan mata pelajaran jika spesifik
    if (mataPelajaran.isNotEmpty) {
      query = query.where('mataPelajaran', isEqualTo: mataPelajaran);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PenilaianMapelModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addAkhlak(PenilaianAkhlak penilaian) {
    final model = PenilaianAkhlakModel(
      id: '',
      santriId: penilaian.santriId,
      disiplin: penilaian.disiplin,
      adab: penilaian.adab,
      kebersihan: penilaian.kebersihan,
      kerjasama: penilaian.kerjasama,
      catatan: penilaian.catatan,
      tanggal: penilaian.tanggal,
    );

    return _firestore
        .collection('santri')
        .doc(penilaian.santriId)
        .collection('akhlak') // Sub-collection baru 'akhlak'
        .add(model.toFirestore());
  }

  @override
  Stream<List<PenilaianAkhlak>> getAkhlakHistory(String santriId) {
    return _firestore
        .collection('santri')
        .doc(santriId)
        .collection('akhlak')
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PenilaianAkhlakModel.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }

  @override
  Future<void> addKehadiran(Kehadiran kehadiran) {
    final model = KehadiranModel(
      id: '',
      santriId: kehadiran.santriId,
      status: kehadiran.status,
      tanggal: kehadiran.tanggal,
    );

    // Simpan di sub-collection: santri/{id}/kehadiran/{id_absen}
    return _firestore
        .collection('santri')
        .doc(kehadiran.santriId)
        .collection('kehadiran')
        .add(model.toFirestore());
  }

  @override
  Stream<List<Kehadiran>> getKehadiranHistory(String santriId) {
    return _firestore
        .collection('santri')
        .doc(santriId)
        .collection('kehadiran')
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return KehadiranModel.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }
}

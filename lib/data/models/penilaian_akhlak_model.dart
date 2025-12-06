// Lokasi: lib/data/models/penilaian_akhlak_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/penilaian_akhlak.dart';

class PenilaianAkhlakModel extends PenilaianAkhlak {
  PenilaianAkhlakModel({
    required super.id,
    required super.santriId,
    required super.disiplin,
    required super.adab,
    required super.kebersihan,
    required super.kerjasama,
    required super.catatan,
    required super.tanggal,
  });

  factory PenilaianAkhlakModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PenilaianAkhlakModel(
      id: id,
      santriId: data['santriId'] ?? '',
      disiplin: data['disiplin'] ?? 1,
      adab: data['adab'] ?? 1,
      kebersihan: data['kebersihan'] ?? 1,
      kerjasama: data['kerjasama'] ?? 1,
      catatan: data['catatan'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'disiplin': disiplin,
      'adab': adab,
      'kebersihan': kebersihan,
      'kerjasama': kerjasama,
      'catatan': catatan,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
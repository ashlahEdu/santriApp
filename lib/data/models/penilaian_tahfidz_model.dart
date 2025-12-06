// Lokasi: lib/data/models/penilaian_tahfidz_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/penilaian_tahfidz.dart';

class PenilaianTahfidzModel extends PenilaianTahfidz {
  PenilaianTahfidzModel({
    required super.id,
    required super.santriId,
    required super.surah,
    required super.ayat,
    required super.nilaiTajwid,
    required super.tanggal,
  });

  factory PenilaianTahfidzModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PenilaianTahfidzModel(
      id: id,
      santriId: data['santriId'] ?? '',
      surah: data['surah'] ?? '',
      ayat: data['ayat'] ?? 0,
      nilaiTajwid: data['nilaiTajwid'] ?? 0,
      tanggal: (data['tanggal'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'surah': surah,
      'ayat': ayat,
      'nilaiTajwid': nilaiTajwid,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
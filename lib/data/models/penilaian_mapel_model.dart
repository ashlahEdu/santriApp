// Lokasi: lib/data/models/penilaian_mapel_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/penilaian_mapel.dart';

class PenilaianMapelModel extends PenilaianMapel {
  PenilaianMapelModel({
    required super.id,
    required super.santriId,
    required super.mataPelajaran,
    required super.nilaiFormatif,
    required super.nilaiSumatif,
    required super.tanggal,
  });

  factory PenilaianMapelModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PenilaianMapelModel(
      id: id,
      santriId: data['santriId'] ?? '',
      mataPelajaran: data['mataPelajaran'] ?? '',
      nilaiFormatif: data['nilaiFormatif'] ?? 0,
      nilaiSumatif: data['nilaiSumatif'] ?? 0,
      tanggal: (data['tanggal'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'mataPelajaran': mataPelajaran,
      'nilaiFormatif': nilaiFormatif,
      'nilaiSumatif': nilaiSumatif,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
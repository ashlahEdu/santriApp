// Lokasi: lib/data/models/kehadiran_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/kehadiran.dart';

class KehadiranModel extends Kehadiran {
  KehadiranModel({
    required super.id,
    required super.santriId,
    required super.status,
    required super.tanggal,
  });

  factory KehadiranModel.fromFirestore(Map<String, dynamic> data, String id) {
    return KehadiranModel(
      id: id,
      santriId: data['santriId'] ?? '',
      status: data['status'] ?? 'H',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'status': status,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
// Lokasi: lib/data/models/app_user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/user_role.dart';

/// Model untuk serialisasi/deserialisasi AppUser dari/ke Firestore.
class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    required super.email,
    required super.mobileNumber,
    required super.role,
    super.createdAt,
    super.assignedSantriIds = const [],
  });

  /// Factory untuk membuat AppUserModel dari dokumen Firestore
  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUserModel(
      uid: data['uid'] ?? doc.id,
      email: data['email'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      role: UserRoleExtension.fromFirestoreString(data['role'] ?? 'wali'),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      assignedSantriIds: data['assignedSantriIds'] != null
          ? List<String>.from(data['assignedSantriIds'])
          : [],
    );
  }

  /// Factory untuk membuat AppUserModel dari Map
  factory AppUserModel.fromMap(Map<String, dynamic> data, String uid) {
    return AppUserModel(
      uid: uid,
      email: data['email'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      role: UserRoleExtension.fromFirestoreString(data['role'] ?? 'wali'),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      assignedSantriIds: data['assignedSantriIds'] != null
          ? List<String>.from(data['assignedSantriIds'])
          : [],
    );
  }

  /// Konversi ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role.toFirestoreString(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'assignedSantriIds': assignedSantriIds,
    };
  }

  /// Factory untuk membuat AppUserModel dari entity AppUser
  factory AppUserModel.fromEntity(AppUser user) {
    return AppUserModel(
      uid: user.uid,
      email: user.email,
      mobileNumber: user.mobileNumber,
      role: user.role,
      createdAt: user.createdAt,
      assignedSantriIds: user.assignedSantriIds,
    );
  }
}

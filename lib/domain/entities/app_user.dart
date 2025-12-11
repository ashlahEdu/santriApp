// Lokasi: lib/domain/entities/app_user.dart

import 'user_role.dart';

/// Entity untuk merepresentasikan pengguna aplikasi.
/// Berbeda dengan FirebaseAuth User, entity ini menyimpan data tambahan
/// seperti role dan nomor telepon.
class AppUser {
  final String uid;
  final String email;
  final String mobileNumber;
  final UserRole role;
  final DateTime? createdAt;
  final List<String> assignedSantriIds; // Santri yang di-assign (untuk Guru/Wali)

  const AppUser({
    required this.uid,
    required this.email,
    required this.mobileNumber,
    required this.role,
    this.createdAt,
    this.assignedSantriIds = const [],
  });

  /// Cek apakah user bisa melakukan edit (CRUD)
  bool get canEdit => role.canEdit;

  /// Cek apakah user hanya read-only
  bool get isReadOnly => role.isReadOnly;

  /// Cek apakah user adalah admin
  bool get isAdmin => role == UserRole.admin;

  /// Cek apakah user adalah guru
  bool get isGuru => role == UserRole.guru;

  /// Cek apakah user adalah wali
  bool get isWali => role == UserRole.wali;

  /// Cek apakah user bisa akses santri tertentu
  bool canAccessSantri(String santriId) {
    if (role == UserRole.admin) {
      return true; // Admin bisa akses semua
    }
    // Guru dan Wali hanya bisa akses santri yang di-assign
    return assignedSantriIds.contains(santriId);
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, role: ${role.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

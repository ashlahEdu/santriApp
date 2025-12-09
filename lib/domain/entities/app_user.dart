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

  const AppUser({
    required this.uid,
    required this.email,
    required this.mobileNumber,
    required this.role,
    this.createdAt,
  });

  /// Cek apakah user bisa melakukan edit (CRUD)
  bool get canEdit => role.canEdit;

  /// Cek apakah user hanya read-only
  bool get isReadOnly => role.isReadOnly;

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

// Lokasi: lib/domain/entities/user_role.dart

/// Enum untuk mendefinisikan role pengguna dalam aplikasi.
/// - admin: Akses penuh (CRUD semua data)
/// - ustadzWali: Akses penuh (CRUD semua data), sama seperti admin
/// - waliSantri: Read-only (tidak bisa menambah, edit, atau hapus data)
enum UserRole {
  admin,
  ustadzWali,
  waliSantri,
}

/// Extension untuk menambahkan utility methods pada UserRole
extension UserRoleExtension on UserRole {
  /// Mendapatkan nama yang ditampilkan untuk role
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.ustadzWali:
        return 'Ustadz/Wali';
      case UserRole.waliSantri:
        return 'Wali Santri';
    }
  }

  /// Mengkonversi ke string untuk disimpan di Firestore
  String toFirestoreString() {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.ustadzWali:
        return 'ustadz_wali';
      case UserRole.waliSantri:
        return 'wali_santri';
    }
  }

  /// Membuat UserRole dari string Firestore
  static UserRole fromFirestoreString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'ustadz_wali':
        return UserRole.ustadzWali;
      case 'wali_santri':
        return UserRole.waliSantri;
      default:
        return UserRole.waliSantri; // Default ke role paling rendah
    }
  }

  /// Cek apakah role ini bisa melakukan edit (CRUD)
  bool get canEdit {
    return this == UserRole.admin || this == UserRole.ustadzWali;
  }

  /// Cek apakah role ini hanya read-only
  bool get isReadOnly {
    return this == UserRole.waliSantri;
  }
}

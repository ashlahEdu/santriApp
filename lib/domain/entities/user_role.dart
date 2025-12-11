// Lokasi: lib/domain/entities/user_role.dart

/// Enum untuk mendefinisikan role pengguna dalam aplikasi.
/// - admin: Akses penuh (CRUD semua data + kelola user)
/// - guru: Akses santri yang diajar (assigned)
/// - wali: Akses santri yang diwakili (assigned) - read only
enum UserRole {
  admin,
  guru,
  wali,
}

/// Extension untuk menambahkan utility methods pada UserRole
extension UserRoleExtension on UserRole {
  /// Mendapatkan nama yang ditampilkan untuk role
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.guru:
        return 'Guru';
      case UserRole.wali:
        return 'Wali Santri';
    }
  }

  /// Mengkonversi ke string untuk disimpan di Firestore
  String toFirestoreString() {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.guru:
        return 'guru';
      case UserRole.wali:
        return 'wali';
    }
  }

  /// Membuat UserRole dari string Firestore
  static UserRole fromFirestoreString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'guru':
      case 'ustadz_wali': // backward compatibility
        return UserRole.guru;
      case 'wali':
      case 'wali_santri': // backward compatibility
        return UserRole.wali;
      default:
        return UserRole.wali; // Default ke role paling rendah
    }
  }

  /// Cek apakah role ini bisa melakukan edit (CRUD)
  bool get canEdit {
    return this == UserRole.admin || this == UserRole.guru;
  }

  /// Cek apakah role ini hanya read-only
  bool get isReadOnly {
    return this == UserRole.wali;
  }

  /// Cek apakah role ini adalah admin
  bool get isAdmin {
    return this == UserRole.admin;
  }

  /// Cek apakah role ini bisa menambah santri (hanya admin)
  bool get canAddSantri {
    return this == UserRole.admin;
  }

  /// Cek apakah role ini bisa input nilai (admin dan guru)
  bool get canInputNilai {
    return this == UserRole.admin || this == UserRole.guru;
  }
}

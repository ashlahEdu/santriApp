import '../entities/app_user.dart';
import '../entities/user_role.dart';

abstract class UserRepository {
  /// Menyimpan data user ke Firestore termasuk role
  Future<void> saveUserData(
    String uid,
    String email,
    String mobileNumber,
    UserRole role, {
    List<String> assignedSantriIds = const [],
  });

  /// Mengambil data user berdasarkan UID (sekali baca)
  Future<AppUser?> getUserById(String uid);

  /// Stream untuk mengambil data user secara real-time
  Stream<AppUser?> getUserStream(String uid);

  /// Stream untuk mengambil semua user (untuk Admin)
  Stream<List<AppUser>> getAllUsers();

  /// Update role user (untuk Admin)
  Future<void> updateUserRole(String uid, UserRole newRole);

  /// Assign santri ke user (untuk Admin) - berlaku untuk Guru dan Wali
  Future<void> assignSantriToUser(String userUid, List<String> santriIds);

  /// Hapus user dari Firestore (untuk Admin)
  Future<void> deleteUser(String uid);
}
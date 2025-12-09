import '../entities/app_user.dart';
import '../entities/user_role.dart';

abstract class UserRepository {
  /// Menyimpan data user ke Firestore termasuk role
  Future<void> saveUserData(
    String uid,
    String email,
    String mobileNumber,
    UserRole role,
  );

  /// Mengambil data user berdasarkan UID (sekali baca)
  Future<AppUser?> getUserById(String uid);

  /// Stream untuk mengambil data user secara real-time
  Stream<AppUser?> getUserStream(String uid);
}
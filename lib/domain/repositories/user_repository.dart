abstract class UserRepository {
  Future<void> saveUserData(
      String uid, String email, String mobileNumber);
}
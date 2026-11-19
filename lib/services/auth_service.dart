import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginKey = 'is_logged_in';

  // Mengecek apakah pengguna sudah login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  // Menyimpan session login
  static Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
  }

  // Menghapus session ketika logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }
}

// auth_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();  

  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'auth_token';
  final String _userKey = 'user_data';

  // Save user session
    Future<void> saveUserSession(String token, String userData) async {
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userKey, value: userData);
    }

    Future<String?> getToken() async {
      return await _storage.read(key: _tokenKey);
    }

    Future<String?> getUserData() async {
      return await _storage.read(key: _userKey);
    }

  // Clear session (logout)
  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
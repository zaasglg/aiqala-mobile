// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _fullNameKey = 'fullName';

  // Тіркелу функциясы
  Future<bool> register(String username, String password, String fullName) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Пайдаланушы тіркелген бе жоқ па тексеру
      final existingUsername = prefs.getString(_usernameKey);
      if (existingUsername != null && existingUsername == username) {
        return false; // Пайдаланушы атауы бос емес
      }

      // Пайдаланушы деректерін сақтау
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_passwordKey, password);
      await prefs.setString(_fullNameKey, fullName);
      await prefs.setBool(_isLoggedInKey, true);

      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Кіру функциясы
  Future<bool> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedUsername = prefs.getString(_usernameKey);
      final savedPassword = prefs.getString(_passwordKey);

      if (savedUsername == username && savedPassword == password) {
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Шығу функциясы
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Пайдаланушы кірген бе жоқ па тексеру
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('isLoggedIn error: $e');
      return false;
    }
  }

  // Пайдаланушы аты-жөнін алу
  Future<String> getFullName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_fullNameKey) ?? 'Пайдаланушы';
    } catch (e) {
      print('getFullName error: $e');
      return 'Пайдаланушы';
    }
  }
}
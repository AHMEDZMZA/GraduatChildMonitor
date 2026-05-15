import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';

  TokenStorage({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _secureStorage.read(key: _emailKey);
  }

  Future<void> clearAuth() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _emailKey);
  }

  Future<bool> isTokenAvailable() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

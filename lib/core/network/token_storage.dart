import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';

  String? _cachedToken;
  String? _cachedEmail;

  TokenStorage({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _secureStorage.read(key: _tokenKey);
    return _cachedToken;
  }

  Future<void> saveEmail(String email) async {
    _cachedEmail = email;
    await _secureStorage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async {
    if (_cachedEmail != null) return _cachedEmail;
    _cachedEmail = await _secureStorage.read(key: _emailKey);
    return _cachedEmail;
  }

  Future<void> clearAuth() async {
    _cachedToken = null;
    _cachedEmail = null;
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _emailKey);
  }

  Future<bool> isTokenAvailable() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A singleton service class to handle secure storage of tokens.
class SecureStorageService {
  // Private constructor
  SecureStorageService._internal();

  // Singleton instance
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  // Access point for the singleton
  factory SecureStorageService() => _instance;

  // Configure secure storage options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Storage Keys
  static const String _accessTokenKey = 'ACCESS_TOKEN';

  // ------------------ Access Token ------------------

  /// Saves the access token securely.
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Retrieves the access token. Returns null if it doesn't exist.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // ------------------ Deletion / Cleanup ------------------

  /// Deletes only the access token.
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Deletes all securely stored authentication data.
  Future<void> deleteAllTokens() async {
    await _storage.deleteAll();
  }
}

import 'secure_storage.dart';

abstract class TokenProvider {
  Future<String?> getToken();
}

class AppTokenProvider implements TokenProvider {
  final SecureStorageService _secureStorage;

  AppTokenProvider({required SecureStorageService secureStorage})
    : _secureStorage = secureStorage;

  @override
  Future<String?> getToken() async {
    return _secureStorage.getAccessToken();
  }
}

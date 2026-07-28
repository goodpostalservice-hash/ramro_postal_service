import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:ramro_postal_service/core/models/user_model.dart';
import 'package:ramro_postal_service/splash.dart';

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '/tmp';

  @override
  Future<String?> getApplicationSupportPath() async => '/tmp';

  @override
  Future<String?> getTemporaryPath() async => '/tmp';

  @override
  Future<String?> getLibraryPath() async => '/tmp';

  @override
  Future<String?> getDownloadsPath() async => '/tmp';

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async => ['/tmp'];

  @override
  Future<String?> getExternalStoragePath() async => '/tmp';

  @override
  Future<String?> getApplicationCachePath() async => '/tmp';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserDataAdapter());
    }
    await Hive.deleteBoxFromDisk('testBox');
  });

  test(
    'UserData Hive adapter preserves userType across a round trip',
    () async {
      final box = await Hive.openBox<UserData>('testBox');
      final original = UserData(userType: 'driver');

      await box.put('user', original);
      final restored = box.get('user');

      expect(restored?.userType, 'driver');

      await box.close();
    },
  );

  test('stale login state does not bypass role selection', () {
    final splash = SplashScreenState();
    expect(
      splash.shouldGoToDashboard(
        isLoggedIn: true,
        accessToken: null,
        userType: null,
      ),
      isFalse,
    );
  });

  test(
    'dashboard access is allowed only when login token and role are present',
    () {
      final splash = SplashScreenState();
      expect(
        splash.shouldGoToDashboard(
          isLoggedIn: true,
          accessToken: 'token',
          userType: 'driver',
        ),
        isTrue,
      );
    },
  );
}

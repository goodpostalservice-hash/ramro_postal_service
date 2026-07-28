import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramro_postal_service/core/design_system/design_system.dart';
import 'package:ramro_postal_service/di/initial_binding.dart';
import 'core/models/user_model.dart';
import 'core/network/api_client.dart';
import 'core/services/location_service_permission.dart';
import 'core/storage/secure_storage.dart';
import 'core/storage/storage_util.dart';
import 'core/storage/token_provider.dart';
import 'routes/app_routes.dart';

//other imports

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await dotenv.load();
  await SStorageUtil.initStorage();

  await Get.putAsync<LocationPermissionService>(() async {
    final service = LocationPermissionService();
    await service.checkStatus(); // get initial state
    return service;
  });

  Get.put<SecureStorageService>(SecureStorageService(), permanent: true);

  Get.put<TokenProvider>(
    AppTokenProvider(secureStorage: Get.find<SecureStorageService>()),
    permanent: true,
  );

  Get.put<ApiClient>(
    ApiClient(tokenProvider: Get.find<TokenProvider>()),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // let content draw behind
        statusBarIconBrightness: Brightness.dark, // Android: dark icons
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: appTheme.gray25,
        systemNavigationBarDividerColor: const Color.fromARGB(0, 56, 49, 49),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      initialRoute: AppRoutes.splash,
      initialBinding: InitialBinding(),
      getPages: AppRoutes.pages,
    );
  }
}

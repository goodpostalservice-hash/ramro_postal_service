import 'package:get/get.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';
import '../core/storage/token_provider.dart';
import '../features/auth/presentation/pages/select_role/controllers/select_role_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SecureStorageService>(SecureStorageService(), permanent: true);

    Get.put<TokenProvider>(
      AppTokenProvider(secureStorage: Get.find<SecureStorageService>()),
      permanent: true,
    );

    Get.put<ApiClient>(
      ApiClient(tokenProvider: Get.find<TokenProvider>()),
      permanent: true,
    );

    Get.lazyPut<SelectRoleController>(
      () => SelectRoleController(),
      fenix: true,
    );
  }
}

import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/settings_remote_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../controllers/settings_controller.dart';
import '../../domain/usecases/get_terms_and_conditions_usecase.dart';
import '../../domain/usecases/get_privacy_policy_usecase.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<SettingsRepository>(
      () => SettingsRepositoryImpl(
        remoteDataSource: Get.find<SettingsRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetTermsAndConditionsUseCase>(
      () => GetTermsAndConditionsUseCase(Get.find<SettingsRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetPrivacyPolicyUseCase>(
      () => GetPrivacyPolicyUseCase(Get.find<SettingsRepository>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<SettingsController>(
      () => SettingsController(
        // CONTROLLER_USECASES_START
        getTermsAndConditionsUseCase: Get.find<GetTermsAndConditionsUseCase>(),
        getPrivacyPolicyUseCase: Get.find<GetPrivacyPolicyUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

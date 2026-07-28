import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../controllers/subscription_controller.dart';
import '../../domain/usecases/get_my_subscription_usecase.dart';
import '../../../package/domain/usecases/get_pacakge_usecase.dart';
import '../../domain/usecases/renew_subscription_usecase.dart';
import '../../domain/usecases/subscribe_package_usecase.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionRemoteDataSource>(
      () => SubscriptionRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(
        remoteDataSource: Get.find<SubscriptionRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetMySubscriptionUseCase>(
      () => GetMySubscriptionUseCase(
        Get.find<SubscriptionRepository>(),
      ),
      fenix: true,
    );

  

    Get.lazyPut<RenewSubscriptionUseCase>(
      () => RenewSubscriptionUseCase(
        Get.find<SubscriptionRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SubscribePackageUseCase>(
      () => SubscribePackageUseCase(
        Get.find<SubscriptionRepository>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<SubscriptionController>(
      () => SubscriptionController(
        // CONTROLLER_USECASES_START
        getMySubscriptionUseCase: Get.find<GetMySubscriptionUseCase>(),
        subscribePackageUseCase: Get.find<SubscribePackageUseCase>(),
        renewSubscriptionUseCase: Get.find<RenewSubscriptionUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

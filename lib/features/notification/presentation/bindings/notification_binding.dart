import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(
        remoteDataSource: Get.find<NotificationRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    // USECASE_INJECTIONS_END

    Get.lazyPut<NotificationController>(
      () => NotificationController(
        // CONTROLLER_USECASES_START
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: Get.find<DashboardRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START

    // USECASE_INJECTIONS_END

    Get.lazyPut<DashboardController>(
      () => DashboardController(
        // CONTROLLER_USECASES_START
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

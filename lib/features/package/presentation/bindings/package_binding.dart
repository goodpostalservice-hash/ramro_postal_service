import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/package_remote_data_source.dart';
import '../../data/repositories/package_repository_impl.dart';
import '../../domain/repositories/package_repository.dart';
import '../../domain/usecases/get_pacakge_usecase.dart';
import '../controllers/package_controller.dart';

class PackageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackageRemoteDataSource>(
      () => PackageRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<PackageRepository>(
      () => PackageRepositoryImpl(
        remoteDataSource: Get.find<PackageRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetPacakgeUseCase>(
      () => GetPacakgeUseCase(Get.find<PackageRepository>()),
      fenix: true,
    );
    // USECASE_INJECTIONS_END

    Get.lazyPut<PackageController>(
      () => PackageController(
        // CONTROLLER_USECASES_START
         getPacakgeUseCase: Get.find<GetPacakgeUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

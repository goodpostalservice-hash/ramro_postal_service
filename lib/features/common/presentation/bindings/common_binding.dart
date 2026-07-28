import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/common_remote_data_source.dart';
import '../../data/repositories/common_repository_impl.dart';
import '../../domain/repositories/common_repository.dart';
import '../controllers/common_controller.dart';
import '../../domain/usecases/get_location_name_usecase.dart';
import '../../../address/domain/usecases/add_missing_place_usecase.dart';

class CommonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<CommonRepository>(
      () => CommonRepositoryImpl(
        remoteDataSource: Get.find<CommonRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetLocationNameUseCase>(
      () => GetLocationNameUseCase(Get.find<CommonRepository>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<CommonController>(
      () => CommonController(
        // CONTROLLER_USECASES_START
        getLocationNameUseCase: Get.find<GetLocationNameUseCase>(),

        // CONTROLLER_USECASES_END
      ),
    );
  }
}

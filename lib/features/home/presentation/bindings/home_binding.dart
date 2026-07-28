import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../controllers/home_controller.dart';
import '../../domain/usecases/get_map_data_usecase.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetMapDataUseCase>(
      () => GetMapDataUseCase(Get.find<HomeRepository>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<HomeController>(
      () => HomeController(
        // CONTROLLER_USECASES_START
        getMapDataUseCase: Get.find<GetMapDataUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

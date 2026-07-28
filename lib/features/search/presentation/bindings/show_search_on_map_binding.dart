import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../home/data/datasources/home_remote_data_source.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/domain/usecases/get_map_data_usecase.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../qr/data/datasources/qr_remote_data_source.dart';
import '../../../qr/data/repositories/qr_repository_impl.dart';
import '../../../qr/domain/repositories/qr_repository.dart';
import '../../../qr/domain/usecases/delete_qr_usecase.dart';
import '../../../qr/domain/usecases/generateQR_usecase.dart';
import '../../../qr/domain/usecases/getMyQR_usecase.dart';
import '../../../qr/presentation/controllers/qr_controller.dart';

class ShowSearchOnMapBinding extends Bindings {
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
    Get.lazyPut<GetMapDataUseCase>(
      () => GetMapDataUseCase(Get.find<HomeRepository>()),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        getMapDataUseCase: Get.find<GetMapDataUseCase>(),
        isShowSearchOnMap: true,
      ),
      tag: 'show_search_map',
    );
    // qr code

    Get.lazyPut<QrRemoteDataSource>(
      () => QrRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<QrRepository>(
      () => QrRepositoryImpl(remoteDataSource: Get.find<QrRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<GenerateqrUseCase>(
      () => GenerateqrUseCase(Get.find<QrRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetmyqrUseCase>(
      () => GetmyqrUseCase(Get.find<QrRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteQrUseCase>(
      () => DeleteQrUseCase(Get.find<QrRepository>()),
      fenix: true,
    );

    Get.lazyPut<QrController>(
      () => QrController(
        // CONTROLLER_USECASES_START
        generateqrUseCase: Get.find<GenerateqrUseCase>(),
        getmyqrUseCase: Get.find<GetmyqrUseCase>(),
        deleteQrUseCase: Get.find<DeleteQrUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/qr_remote_data_source.dart';
import '../../data/repositories/qr_repository_impl.dart';
import '../../domain/repositories/qr_repository.dart';
import '../controllers/qr_controller.dart';
import '../../domain/usecases/generateQR_usecase.dart';
import '../../domain/usecases/getMyQR_usecase.dart';
import '../../domain/usecases/delete_qr_usecase.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrRemoteDataSource>(
      () => QrRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<QrRepository>(
      () => QrRepositoryImpl(remoteDataSource: Get.find<QrRemoteDataSource>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
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

    // USECASE_INJECTIONS_END

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

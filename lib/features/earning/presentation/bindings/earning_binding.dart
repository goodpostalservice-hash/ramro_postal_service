import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/earning_remote_data_source.dart';
import '../../data/repositories/earning_repository_impl.dart';
import '../../domain/repositories/earning_repository.dart';
import '../controllers/earning_controller.dart';
import '../../domain/usecases/get_today_earning_usecase.dart';
import '../../domain/usecases/get_earning_usecase.dart';

class EarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarningRemoteDataSource>(
      () => EarningRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
      fenix: true,
    );

    Get.lazyPut<EarningRepository>(
      () => EarningRepositoryImpl(
        remoteDataSource: Get.find<EarningRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetTodayEarningUseCase>(
      () => GetTodayEarningUseCase(
        Get.find<EarningRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GetEarningUseCase>(
      () => GetEarningUseCase(
        Get.find<EarningRepository>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<EarningController>(
      () => EarningController(
        // CONTROLLER_USECASES_START
        getTodayEarningUseCase: Get.find<GetTodayEarningUseCase>(),
        getEarningUseCase: Get.find<GetEarningUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

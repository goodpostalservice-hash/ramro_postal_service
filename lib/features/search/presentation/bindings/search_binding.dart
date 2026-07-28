import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../home/data/datasources/home_remote_data_source.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/domain/usecases/get_map_data_usecase.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/get_search_result_usecase.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(
        remoteDataSource: Get.find<SearchRemoteDataSource>(),
      ),
      fenix: true,
    );

    // home
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
    Get.lazyPut<GetSearchResultUseCase>(
      () => GetSearchResultUseCase(Get.find<SearchRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetMapDataUseCase>(
      () => GetMapDataUseCase(Get.find<HomeRepository>()),
      fenix: true,
    );
    // USECASE_INJECTIONS_END

    Get.lazyPut<SearchAddressController>(
      () => SearchAddressController(
        // CONTROLLER_USECASES_START
        getSearchResultUseCase: Get.find<GetSearchResultUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

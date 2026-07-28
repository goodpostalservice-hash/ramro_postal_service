import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/usecases/add_missing_place_usecase.dart';
import '../../data/datasources/address_remote_data_source.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../controllers/address_controller.dart';
import '../../domain/usecases/getSavedAddress_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';
import '../../domain/usecases/delete_saved_address_usecase.dart';
import '../../../home/data/datasources/home_remote_data_source.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/domain/usecases/get_map_data_usecase.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressRemoteDataSource>(
      () => AddressRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<AddressRepository>(
      () => AddressRepositoryImpl(
        remoteDataSource: Get.find<AddressRemoteDataSource>(),
      ),
      fenix: true,
    );

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

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetsavedaddressUseCase>(
      () => GetsavedaddressUseCase(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<SaveAddressUseCase>(
      () => SaveAddressUseCase(Get.find<AddressRepository>()),
      fenix: true,
    );
    Get.lazyPut<AddMissingPlaceUseCase>(
      () => AddMissingPlaceUseCase(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteSavedAddressUseCase>(
      () => DeleteSavedAddressUseCase(Get.find<AddressRepository>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<AddressController>(
      () => AddressController(
        // CONTROLLER_USECASES_START
        getsavedaddressUseCase: Get.find<GetsavedaddressUseCase>(),
        saveAddressUseCase: Get.find<SaveAddressUseCase>(),
        addMissingPlaceUseCase: Get.find<AddMissingPlaceUseCase>(),
        deleteSavedAddressUseCase: Get.find<DeleteSavedAddressUseCase>(),
        getMapDataUseCase: Get.find<GetMapDataUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

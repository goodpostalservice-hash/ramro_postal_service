import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../controllers/profile_controller.dart';
import '../../domain/usecases/getProfile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: Get.find<ProfileRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetprofileUseCase>(
      () => GetprofileUseCase(
        Get.find<ProfileRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(
        Get.find<ProfileRepository>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<ProfileController>(
      () => ProfileController(
        // CONTROLLER_USECASES_START
        getprofileUseCase: Get.find<GetprofileUseCase>(),
        updateProfileUseCase: Get.find<UpdateProfileUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

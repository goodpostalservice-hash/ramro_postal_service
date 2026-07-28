import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/check_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<CheckOtpUseCase>(
      () => CheckOtpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<ResendOtpUseCase>(
      () => ResendOtpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<LogoutUseCase>(
      () => LogoutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<AuthController>(
      () => AuthController(
        // CONTROLLER_USECASES_START
        loginUseCase: Get.find<LoginUseCase>(),

        registerUseCase: Get.find<RegisterUseCase>(),
        checkOtpUseCase: Get.find<CheckOtpUseCase>(),
        resendOtpUseCase: Get.find<ResendOtpUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

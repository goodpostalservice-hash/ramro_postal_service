import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/wallet_remote_data_source.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../controllers/wallet_controller.dart';
import '../../domain/usecases/get_wallet_usecase.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
      fenix: true,
    );

    Get.lazyPut<WalletRepository>(
      () => WalletRepositoryImpl(
        remoteDataSource: Get.find<WalletRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetWalletUseCase>(
      () => GetWalletUseCase(
        Get.find<WalletRepository>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<WalletController>(
      () => WalletController(
        // CONTROLLER_USECASES_START
        getWalletUseCase: Get.find<GetWalletUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
  }
}

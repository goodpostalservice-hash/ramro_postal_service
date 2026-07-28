import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_wallet.dart';
import '../../domain/usecases/get_wallet_usecase.dart';

class WalletController extends GetxController {
  // USECASE_FIELDS_START

  final GetWalletUseCase getWalletUseCase;
  // USECASE_FIELDS_END

  WalletController({
    // USECASE_CONSTRUCTOR_START
    required this.getWalletUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  var walletResult = UserWallet().obs;
  @override
  void onReady() {
    super.onReady();

    getWallet();
  }

  // API_METHODS_START
  // API_METHODS_END
  Future<void> getWallet() async {
    try {
      isLoading.value = true;

      final result = await getWalletUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          walletResult.value = response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

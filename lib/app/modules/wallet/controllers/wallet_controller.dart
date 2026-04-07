import 'package:get/get.dart';
import 'package:ramro_postal_service/app/data/services/wallet/wallet_service.dart';

import '../../../core/common_widgets/center_loading_bar.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/general/api_result.dart';
import '../../../data/models/user_wallet/user_wallet.dart';

class WalletController extends GetxController {
 
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Get.showOverlay(
      asyncFunction: getUserWallet,
      loadingWidget: const CenterLoadingBar(),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  var walletResult = APIResult<UserWallet>().obs;

  Future<void> getUserWallet() async {
    walletResult.value = APIResult.loading();

    var response = await WalletService.getWalletData();
    walletResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r),
    );

    if (walletResult.value.isSuccessful) {
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        walletResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }
}

import 'package:get/get.dart';

import '../../../core/common_widgets/center_loading_bar.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/general/api_result.dart';
import '../../../data/models/my_subscription_response/my_subscription_response.dart';
import '../../../data/services/my_subscripiton/my_subscription_service.dart';

class MySubscriptionController extends GetxController {

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Get.showOverlay(
      asyncFunction: getMySubscription,
      loadingWidget: const CenterLoadingBar(),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  var walletResult = APIResult<MySubscriptionResponse>().obs;

  Future<void> getMySubscription() async {
    walletResult.value = APIResult.loading();

    var response = await MySubscriptionService.getMySubscription();
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

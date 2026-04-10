import 'package:get/get.dart';

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
    getMySubscription();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  var mySubscriptionResult = APIResult<MySubscriptionResponse>().obs;

  Future<void> getMySubscription() async {
    mySubscriptionResult.value = APIResult.loading();

    var response = await MySubscriptionService.getMySubscription();
    mySubscriptionResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r),
    );

    if (mySubscriptionResult.value.isSuccessful) {
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        mySubscriptionResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }
}

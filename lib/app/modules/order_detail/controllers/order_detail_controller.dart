import 'package:get/get.dart';
import 'package:ramro_postal_service/app/data/services/order_detail/order_detail_service.dart';

import '../../../core/common_widgets/center_loading_bar.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/general/api_result.dart';
import '../../../data/models/order_detail_response/order.dart';

class OrderDetailController extends GetxController {
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Get.showOverlay(
      asyncFunction: getOrderDetail,
      loadingWidget: const CenterLoadingBar(),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  var orderResult = APIResult<Order>().obs;

  Future<void> getOrderDetail() async {
    orderResult.value = APIResult.loading();

    var response = await OrderDetailService.getOrderDetail(
      orderId: (Get.arguments as int?) ?? 0,
    );
    orderResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r.order ?? Order()),
    );

    if (orderResult.value.isSuccessful) {
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        orderResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }
}

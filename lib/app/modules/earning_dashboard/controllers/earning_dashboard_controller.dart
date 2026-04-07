import 'package:get/get.dart';

import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/earning_response.dart';
import '../../../data/models/general/api_result.dart';
import '../../../data/models/today_earning_response.dart';
import '../../../data/services/earning_dashboard/earning_dashboard_service.dart';

class EarningDashboardController extends GetxController {
  //TODO: Implement EarningDashboardController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getTodayEarningDetail();
    getEarning();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var todayEarningResult = APIResult<TodayEarningResponse>().obs;

  Future<void> getTodayEarningDetail() async {
    todayEarningResult.value = APIResult.loading();

    var response = await EarningDashboardService.getTodayEarning();
    todayEarningResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r),
    );

    if (todayEarningResult.value.isSuccessful) {
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        todayEarningResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }

  // get Earning
  var earningResult = APIResult<EarningResponse>().obs;

  Future<void> getEarning() async {
    earningResult.value = APIResult.loading();
    var response = await EarningDashboardService.getEarning();
    earningResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r),
    );

    if (earningResult.value.isSuccessful) {
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        earningResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }
}

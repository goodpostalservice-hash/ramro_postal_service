import 'package:get/get.dart';

import '../controllers/earning_dashboard_controller.dart';

class EarningDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarningDashboardController>(() => EarningDashboardController());
  }
}

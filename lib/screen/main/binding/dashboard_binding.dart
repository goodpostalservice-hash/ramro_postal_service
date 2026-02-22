import 'package:get/get.dart';
import 'package:ramro_postal_service/screen/main/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: false);
  }
}

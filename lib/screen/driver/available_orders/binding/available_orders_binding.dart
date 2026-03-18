import 'package:get/get.dart';
import '../controller/available_orders_controller.dart';

class AvailablePackages extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvailablePackageController>(
      () => AvailablePackageController(),
      fenix: true,
    );
  }
}

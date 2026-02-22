import 'package:get/get.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/controller/home_driver_map_controller.dart';

class PickUpHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDriverMapController>(() => HomeDriverMapController(),
        fenix: false);
  }
}

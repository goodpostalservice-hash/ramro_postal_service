import 'package:get/get.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/controller/home_map_controller.dart';

class HomeMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeMapController>(() => HomeMapController(), fenix: false);
  }
}

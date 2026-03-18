import 'package:get/get.dart';
import 'package:ramro_postal_service/screen/common/about/controller/help_controller.dart';

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(() => AboutController(), fenix: true);
  }
}

import 'package:get/get.dart';
import 'package:ramro_postal_service/screen/no_internet/no_internet_controller.dart';



class NoInternetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoInternetController>(() => NoInternetController(),
        fenix: true);
  }
}

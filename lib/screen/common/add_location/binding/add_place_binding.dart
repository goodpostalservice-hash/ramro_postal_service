import 'package:get/get.dart';
import '../controller/add_place_controller.dart';

class AddPlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPlaceController>(() => AddPlaceController(), fenix: true);
  }
}

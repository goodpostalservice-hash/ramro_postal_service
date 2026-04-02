import 'package:get/get.dart';
import '../controller/saved_address_controller.dart';

class SavedAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedAddressController>(
      () => SavedAddressController(),
      fenix: true,
    );
  }
}

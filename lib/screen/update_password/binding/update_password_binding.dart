import 'package:get/get.dart';
import '../controller/update_password_controller.dart';

class UppdatePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdatePasswordController>(
      () => UpdatePasswordController(),
      fenix: true,
    );
  }
}

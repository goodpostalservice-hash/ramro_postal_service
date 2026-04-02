import 'package:get/get.dart';
import '../controller/change_forget_password_controller.dart';

class ChangeForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeForgetPasswordController>(
      () => ChangeForgetPasswordController(),
      fenix: true,
    );
  }
}

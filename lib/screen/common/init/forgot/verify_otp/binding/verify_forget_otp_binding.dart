import 'package:get/get.dart';
import '../controller/verify_forget_otp_controller.dart';

class VerifyForgetOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyForgetOTPController>(
      () => VerifyForgetOTPController(),
      fenix: true,
    );
  }
}

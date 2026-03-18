import 'package:get/get.dart';
import '../controller/send_otp_controller.dart';

class SendOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendOTPController>(() => SendOTPController(), fenix: true);
  }
}
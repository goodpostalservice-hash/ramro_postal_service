import 'package:get/get.dart';
import '../controller/my_qr_controller.dart';

class MyQRBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyQRController>(() => MyQRController(), fenix: true);
  }
}

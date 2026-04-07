import 'package:get/get.dart';

class SelectRoleController extends GetxController {
  //TODO: Implement SelectRoleController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  final Rx<String?> selectedRole = Rx<String?>(null);
}

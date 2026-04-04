import 'package:get/get.dart';

import '../controllers/select_role_controller.dart';

class SelectRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectRoleController>(() => SelectRoleController());
  }
}

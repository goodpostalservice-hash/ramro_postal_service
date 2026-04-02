import 'package:get/get.dart';

import '../controllers/my_subscription_controller.dart';

class MySubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MySubscriptionController>(() => MySubscriptionController());
  }
}

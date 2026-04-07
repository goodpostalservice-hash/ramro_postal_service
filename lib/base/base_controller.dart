import 'package:get/get.dart';
import '../core/network/network_dio.dart';

class BaseController extends GetxController {
  late RestClient restClient;

  @override
  onInit() {
    super.onInit();
    restClient = Get.find();
  }
}

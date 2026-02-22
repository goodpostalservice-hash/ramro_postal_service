import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/base/base_controller.dart';
import 'package:ramro_postal_service/screen/no_internet/no_internet_connection.dart';

class NoInternetController extends BaseController {
  final Connectivity _connectivityPlus = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivityPlus.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.first == ConnectivityResult.none) {
      Get.to(() => const NoInternetConnection());
    }
  }
}

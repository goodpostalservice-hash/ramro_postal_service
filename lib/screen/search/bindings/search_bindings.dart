import 'package:get/get.dart';
import 'package:ramro_postal_service/screen/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchMapController>(() => SearchMapController(), fenix: true);
  }
}

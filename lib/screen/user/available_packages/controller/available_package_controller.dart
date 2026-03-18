import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ramro_postal_service/base/base_controller.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/core/network/network_dio.dart';

import '../model/available_package_model.dart';

class AvailablePackageController extends BaseController {
  List<AvailablePackageModel> availablePackages = <AvailablePackageModel>[].obs;
  RxBool isLoading = false.obs;
  fetchAvailablePackages() async {
    final map = <String, dynamic>{};
    try {
      isLoading.value = true;
      final result = await restClient.request(
        ApiConstant.availablePackages,
        Method.GET,
        map,
      );
      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value
          availablePackages.clear();
          List<dynamic> myList = result.data;
          for (int i = 0; i < myList.length; i++) {
            var responseData = AvailablePackageModel.fromJson(myList[i]);

            availablePackages.add(responseData);
          }
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } on Exception {
      isLoading.value = false;
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAvailablePackages();
  }
}

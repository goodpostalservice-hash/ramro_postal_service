import 'package:get/get.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import '../../../base/base_controller.dart';
import '../../../core/constants/api_constant.dart';
import 'package:dio/dio.dart' as dio;

import '../../../core/network/network_dio.dart';

class SearchMapController extends BaseController {
  List<MapModel> searchResultList = <MapModel>[].obs;
  getSearchAddresses(String? data) async {
    try {
      final map = {"data": data};

      final result =
          await restClient.request(ApiConstant.searchResult, Method.POST, map);

      if (result != null) {
        if (result is dio.Response) {
          if (result.data != []) {
            searchResultList.clear();
            List<dynamic> myList = result.data;
            for (int i = 0; i < myList.length; i++) {
              var responseData = MapModel.fromJson(myList[i]);
              searchResultList.add(responseData);
            }
            return result.data;
          } else {
            showErrorMessage(result.data['message'].toString());
          }
        }
      } else {}
    } on Exception {
      showErrorMessage('Something went wrong. Please try again later.');
    }
  }
}

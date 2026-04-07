import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import '../../../../base/base_controller.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/network/network_dio.dart';
import '../model/delete_qr_response_model.dart';
import '../model/is_defaul_response_model.dart';
import '../model/my_qr_response_model.dart';

class MyQRController extends BaseController {
  List<MyQRResponseModel> resultList = <MyQRResponseModel>[].obs;
  var isToLoadMore = true;

  final isEmpty = false.obs;

  // dropdown value
  String? selectedValue;

  // check box
  final myCheckBoxValue = false.obs;

  // delete button loader
  final isDeleting = false.obs;

  @override
  onInit() {
    super.onInit();
    loadMyQRData();
  }

  loadMyQRData() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.myQR,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value
          resultList.clear();

          List<dynamic> myList = result.data;
          for (int i = 0; i < myList.length; i++) {
            var responseData = MyQRResponseModel.fromJson(myList[i]);
            resultList.add(responseData);
          }

          if (resultList.isEmpty) {
            isEmpty.value = true;
          } else {
            isEmpty.value = false;
          }

          isToLoadMore = true;
        }
      } else {
        isToLoadMore = false;
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }

  deleteSelectedQR(String selectedId, String index) async {
    isDeleting.value = true;

    try {
      final map = {'id': selectedId};

      final result = await restClient.request(
        ApiConstant.deleteQR,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = DeleteQRResponseModel.fromJson(result.data);
          if (responseData.success == true) {
            resultList.removeAt(0);
            loadMyQRData();
            isDeleting.value = false;
            Get.back();
          } else {
            isDeleting.value = false;
            showErrorMessage(responseData.message.toString());
          }
        }
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/password');
      isDeleting.value = false;
      showErrorMessage('Something went wrong');
    }
  }

  isDefaultQR(String id, String isDefault) async {
    try {
      final map = {'id': id, 'is_default': isDefault};

      final result = await restClient.request(
        ApiConstant.setDefault,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = IsDefaultResponseModel.fromJson(result.data);
          if (responseData.success == true) {
            myCheckBoxValue.value = false;
            resultList.removeAt(0);
            loadMyQRData();
            Get.back();
          } else {
            showErrorMessage(responseData.message.toString());
          }
        }
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/password');
      showErrorMessage('Something went wrong');
    }
  }

  changeSelectedValue(String myValue) {
    selectedValue = myValue;
    print("Selected value is: $myValue");
  }

  changeCheckBoxValue(bool myValue) {
    myCheckBoxValue.value = myValue;
  }
}

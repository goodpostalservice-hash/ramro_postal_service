import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/screen/common/myQR/controller/my_qr_controller.dart';
import '../../../base/base_controller.dart';
import '../../../core/constants/api_constant.dart';
import '../../../core/network/network_dio.dart';
import '../model/delete_qr_response_model.dart';
import '../model/my_qr_response_model.dart';

class SavedAddressController extends BaseController {
  List<MyQRResponseModel> resultList = <MyQRResponseModel>[].obs;
  MyQRResponseModel? myDefaultQR;
  RxBool isToLoadMore = true.obs;
  RxList<int> selectedId = <int>[].obs;
  RxList<bool> selectedItems = <bool>[].obs;
  // dropdown value
  String? selectedValue;

  // check box
  var myCheckBoxValue = false.obs;

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
          selectedItems.clear();
          List<dynamic> myList = result.data;
          for (int i = 0; i < myList.length; i++) {
            var responseData = MyQRResponseModel.fromJson(myList[i]);
            selectedItems.add(false);
            if (responseData.isDefault == 1) {
              myDefaultQR = responseData;
            }
            resultList.add(responseData);
          }
          isToLoadMore.value = false;
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      isToLoadMore.value = false;
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }

  saveQR(
    String longitude,
    String latitude,
    String address,
    String? addressType,
    bool isDefault,
  ) async {
    final map = <String, dynamic>{
      'longitude': longitude,
      'latitude': latitude,
      'address_map': address,
      'address_type': addressType ?? 'other',
      'is_default': isDefault == true ? '1' : '0',
    };

    final result = await restClient.request(
      ApiConstant.addLocation,
      Method.POST,
      map,
    );
    if (result != null) {
      if (result is dio.Response) {
        var responseData = result.data;
        if (result.statusCode == 200) {
          showSuccessMessage("address saved successfully");

          await loadMyQRData();
          final myAddressController = Get.put(MyQRController());
          await myAddressController.loadMyQRData();
        } else {
          showErrorMessage("failed to save address");
        }
      }
    }
  }

  deleteQR(int id) async {
    try {
      Map<String, dynamic> map = {
        "id": [id],
      };
      final result = await restClient.request(
        ApiConstant.deleteQR,
        Method.POST_JSON,
        map,
      );

      if (result.data['success'] = true) {
        if (result is dio.Response) {
          resultList.removeAt(0);
          loadMyQRData();
          final myAddressController = Get.put(MyQRController());
          await myAddressController.loadMyQRData();
          Get.back();
        }
      } else {
        showErrorMessage('failed to delete  data');
      }
    } on Exception catch (e) {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/password');
      print(e.toString());
      showErrorMessage('Something went wrong');
    }
  }

  deleteSelectedQR(List<int> selectedId) async {
    try {
      final map = {'id': selectedId};
      final result = await restClient.request(
        ApiConstant.deleteQR,
        Method.POST_JSON,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = DeleteQRResponseModel.fromJson(result.data);
          if (responseData.success == true) {
            for (var i = 0; i < selectedId.length; i++) {
              resultList.removeWhere((item) => item.id == selectedId[i]);
            }
            selectedItems.clear();
            selectedId.clear();
            loadMyQRData();
          } else {
            showErrorMessage(responseData.message.toString());
          }
        }
      }
    } on Exception catch (e) {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/password');
      print(e.toString());
      showErrorMessage('Something went wrong');
    }
  }

  changeSelectedValue(String myValue) {
    selectedValue = myValue;
    print("Selected value is: $myValue");
  }

  changeCheckBoxValue(bool myValue) {
    myCheckBoxValue = myValue.obs;
  }
}

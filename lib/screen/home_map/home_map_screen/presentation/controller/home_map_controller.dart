import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ramro_postal_service/base/base_controller.dart';
import 'package:ramro_postal_service/core/constants/api_constant.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/core/network/network_dio.dart';
import 'package:ramro_postal_service/modal/map_model.dart';

import 'package:dio/dio.dart' as dio;
import 'package:ramro_postal_service/screen/myQR/controller/my_qr_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
import 'package:ramro_postal_service/user/home/view/user_home_screen.dart';

class HomeMapController extends BaseController {
  List<MapModel> houseList = <MapModel>[].obs;
  Rx<LatLng> center = const LatLng(27.675859, 85.351339).obs;
  RxDouble currentZoom = 0.0.obs;
  Set<Marker> markers = <Marker>{}.obs;
  RxBool isMyLocationButtonVisible = true.obs;
  // Rx<LocationData> myCurrentLocation =
  //     LocationData.fromMap({"latitude": 27.675859, "longitude": 85.351339}).obs;
  Rx<LocationData> myCurrentLocation = LocationData.fromMap({
    "latitude": HomeMapScreen.currentLocationAtStart!.latitude,
    "longitude": HomeMapScreen.currentLocationAtStart!.longitude
  }).obs;

  getHouseList(double latitude, double longitude) async {
    try {
      final map = <String, dynamic>{
        "latitude": latitude,
        "longitude": longitude,
        "distance": 0.1
      };

      final result =
          await restClient.request(ApiConstant.houseNumber, Method.GET, map);

      if (result != null) {
        if (result is dio.Response) {
          List<dynamic> myList = result.data;
          List<MapModel> myHouseNum = [];
          for (int i = 0; i < myList.length; i++) {
            var responseData = MapModel.fromJson(myList[i]);
            myHouseNum.add(responseData);
          }

          return myHouseNum;
          // if (result.statusCode == 200) {

          //   print(houseList.length);

          //   // redirect to main screen
          //   // Get.offNamed('/dashboard');
          // } else {
          //   print(" error");
          //   // showErrorMessage(result.data.message.toString());
          // }
        }
      } else {}
    } on Exception {
      Get.toNamed("/no_internet");
      // showErrorMessage('Something went wrong. Please try again later.');
    }
  }

  saveQR(String longitude, String latitude, String address, String? addressType,
      bool isDefault) async {
    final map = <String, dynamic>{
      'longitude': longitude,
      'latitude': latitude,
      'address_map': address,
      'address_type': addressType ?? 'Other'
    };
    final result =
        await restClient.request(ApiConstant.addLocation, Method.POST, map);
    if (result != null) {
      if (result is dio.Response) {
        var responseData = result.data;
        if (result.statusCode == 200) {
          showSuccessMessage("address saved successfully");

          // redirect to main screen
          Get.offNamed('/dashboard');
          final savedAddrescontroller = Get.put(SavedAddressController());
          await savedAddrescontroller.loadMyQRData();
          final myAddressController = Get.put(MyQRController());
          await myAddressController.loadMyQRData();
          Get.back();
        } else {
          showErrorMessage("failed to save address");
        }
      }
    }
  }
}

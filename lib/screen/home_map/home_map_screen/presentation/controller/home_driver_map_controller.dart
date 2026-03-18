import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/base/base_controller.dart';
import 'package:ramro_postal_service/core/constants/api_constant.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/core/network/network_dio.dart';
import 'package:ramro_postal_service/modal/map_model.dart';

import 'package:dio/dio.dart' as dio;
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/driver_home_map_screen.dart';
import 'package:ramro_postal_service/screen/common/myQR/controller/my_qr_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';

class HomeDriverMapController extends BaseController {
  List<MapModel> houseList = <MapModel>[].obs;

  Rx<LatLng> center = const LatLng(27.675859, 85.351339).obs;
  RxDouble currentZoom = 0.0.obs;

  Rx<LatLng> myCurrentLocation = LatLng(
    DriverHomeMapScreen.currentLocationAtStart!.latitude,
    DriverHomeMapScreen.currentLocationAtStart!.longitude,
  ).obs;
  RxString myCurrentLocationName = ''.obs;
  RxString myDestinationName = ''.obs;
  RxBool isMyLocationButtonVisible = true.obs;
  RxBool isGetDirectionEnabled = false.obs;
  RxBool isGetDirectionClicked = false.obs;
  Set<Marker> driverMarker = <Marker>{}.obs;
  Set<Marker> locationMarker = <Marker>{}.obs;
  Rx<LatLng> destinationCoordinates = LatLng(27.675859, 85.351339).obs;
  RxBool isLoading = false.obs;
  RxList<bool> isButtonClicked = <bool>[].obs;
  RxDouble remainingDistance = 0.0.obs;

  getFreshLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    myCurrentLocation.value = LatLng(position.latitude, position.longitude);
  }

  getHouseList(double latitude, double longitude) async {
    try {
      final map = <String, dynamic>{
        "latitude": latitude,
        "longitude": longitude,
        "distance": 0.05,
      };

      final result = await restClient.request(
        ApiConstant.houseNumber,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          List<dynamic> myList = result.data;
          List<MapModel> myHouseNum = [];
          for (int i = 0; i < myList.length; i++) {
            var responseData = MapModel.fromJson(myList[i]);
            myHouseNum.add(responseData);
          }

          return myHouseNum;
        }
      } else {}
    } on SocketException {
      Get.toNamed("/no_internet");
      // showErrorMessage('Something went wrong. Please try again later.');
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
    isLoading.value = true;

    final result = await restClient.request(
      ApiConstant.addLocation,
      Method.POST,
      map,
    );
    if (result != null) {
      if (result is dio.Response) {
        var responseData = result.data;
        if (result.statusCode == 200) {
          isLoading.value = false;

          showSuccessMessage("address saved successfully");
          final savedAddrescontroller = Get.put(SavedAddressController());
          await savedAddrescontroller.loadMyQRData();
          final myAddressController = Get.put(MyQRController());
          await myAddressController.loadMyQRData();
          Get.back();

          // redirect to main screen
          Get.offNamed('/dashboard');
        } else {
          isLoading.value = false;
          showErrorMessage("failed to save address");
        }
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    driverMarker.clear();
    super.onClose();
  }

  // getCurrentLoccation() async {
  //   Position position = await Geolocator.getCurrentPosition();
  //   DriverHomeMapScreen.currentLocationAtStart =
  //       LatLng(position.latitude, position.longitude);
  //   myCurrentLocation.value = LocationData.fromMap(
  //       {"latitude": position.latitude, "longitude": position.longitude});
  // }
}

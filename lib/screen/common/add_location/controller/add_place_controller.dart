import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import 'package:ramro_postal_service/screen/user/widget/place_list.dart';
import '../../../../../base/base_controller.dart';
import '../../../../../core/constants/api_constant.dart';
import '../../../../../core/error/toast.dart';
import '../../../../../core/network/network_dio.dart';
import 'package:dio/dio.dart' as dio;

import '../model/add_missing_place_model.dart';

class AddPlaceController extends BaseController {
  // final LatLng initialPosition = LatLng(AddPlaceScreen.lat!,AddPlaceScreen.lng!); // Initial map position
  final LatLng initialPosition =
      const LatLng(27.712405, 85.353815); // Initial map position
  GoogleMapController? mapController;

  final placeNameController = TextEditingController();
  final addressController = TextEditingController();
  final houseNumberController = TextEditingController();

  final isToLoadMore = false.obs;
  final selectedIndex = 0.obs;
  final selectedValue = ''.obs;
  final selectedItem = PlaceList
      .allList[0].obs; // Assuming the first item as the default selected item.

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void selectChip(int index) {
    selectedIndex.value = index;
    selectedValue.value = PlaceList.allList[index].toString();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  addMissingPlace(String latitude, String longitude, String locationName,
      String fullAddressDetail, String houseNumber) async {
    isToLoadMore.value = true;

    try {
      final map = {
        'latitude': latitude,
        'longitude': longitude,
        'location_name': locationName,
        'full_address_detail': fullAddressDetail,
        'house_num': houseNumber
      };

      final result = await restClient.request(
          ApiConstant.addMissingPlace, Method.POST, map);

      if (result != null) {
        if (result is dio.Response) {
          var responseData = AddMissingPlaceResponseModel.fromJson(result.data);
          if (result.statusCode == 200) {
            showSuccessMessage(responseData.message.toString());
            isToLoadMore.value = false;

            // redirect to main screen
            Get.offNamed('/dashboard');
          } else {
            showErrorMessage(responseData.message.toString());
            isToLoadMore.value = false;
          }
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception {
      isToLoadMore.value = false;
      showErrorMessage('Something went wrong. Please try again later.');
    }
  }

  getHouseList(double latitude, double longitude) async {
    try {
      final map = <String, dynamic>{
        "latitude": latitude,
        "longitude": longitude,
        "distance": 0.2
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
    } on SocketException {
      Get.toNamed("/no_internet");
      // showErrorMessage('Something went wrong. Please try again later.');
    }
  }
}

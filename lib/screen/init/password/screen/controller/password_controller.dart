import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/driver_home_map_screen.dart';
import 'package:ramro_postal_service/user/home/view/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../base/base_controller.dart';
import '../../../../../core/constants/api_constant.dart';
import '../../../../../core/constants/app_constant.dart';
import '../../../../../core/error/toast.dart';
import '../../../../../core/network/network_dio.dart';
import '../../../register/screen/register.dart';
import '../model/login_response_model.dart';

class PasswordController extends BaseController {
  final isToLoadMore = false.obs;
  final isPasswordVisible = true.obs;
  var showPassword = false.obs;

  checkPasswordField(String phone, String password) async {
    isToLoadMore.value = true;

    RegisterScreen.phone = phone;
    final status = OneSignal.User.pushSubscription.id;

    //  await OneSignal.shared.getDeviceState();
    final String? osUserID = status;
    try {
      final map = {
        'phone': phone,
        'password': password,
        "unique_token": osUserID,
        'deviceid': await getDeviceId(),
      };

      print(map.toString());

      final result = await restClient.request(
        ApiConstant.login,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = LoginResponseModel.fromJson(result.data);
          if (responseData.success == true) {
            AppConstant.bearerToken = responseData.token.toString();

            // after login clear the temp list and store new value
            AppConstant.logInfo = [];

            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // Map<String, dynamic> map = result.data;
            // prefs.setString('key', json.encode(map));

            // AppConstant.logInfo.add(result.data);

            isToLoadMore.value = false;

            // Your JSON data
            final userData = result.data;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            // clear all the values for sharedpreferences
            prefs.clear();

            // store new logged in data
            Map<String, dynamic> map = userData;
            prefs.setString('key', json.encode(map));

            // save in list
            AppConstant.logInfo.add(result.data);

            // save the usertype value
            if (AppConstant.logInfo[0]['data']['user_type'].toString() == "0") {
              // logged in as normal user
              AppConstant.loggedInUserType = 'user';
            } else if (AppConstant.logInfo[0]['data']['user_type'].toString() ==
                "3") {
              AppConstant.loggedInUserType = 'driver';
            } else {
              AppConstant.loggedInUserType = 'merchant';
            }
            // Position position = await Geolocator.getCurrentPosition(
            //     desiredAccuracy: LocationAccuracy.high);
            // HomeMapScreen.currentLocationAtStart =
            //     LatLng(position.latitude, position.longitude);
            // DriverHomeMapScreen.currentLocationAtStart =
            //     LatLng(position.latitude, position.longitude);
            // redirect to main screen
            Position position = await Geolocator.getCurrentPosition();
            DriverHomeMapScreen.currentLocationAtStart = LatLng(
              position.latitude,
              position.longitude,
            );
            HomeMapScreen.currentLocationAtStart = LatLng(
              position.latitude,
              position.longitude,
            );

            Get.offNamed('/dashboard');

            showSuccessMessage("Login success");
          } else {
            showErrorMessage(responseData.message.toString());
            isToLoadMore.value = false;
          }
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      Get.offAllNamed('/register');
      isToLoadMore.value = false;
      showErrorMessage('Exceptional error');
    }
  }

  Future<String> getDeviceId() async {
    String deviceid;
    var deviceState = OneSignal.User.pushSubscription.id;
    if (deviceState == null) {
      return '';
    } else {
      deviceid = deviceState;
    }
    return deviceState;
  }
}

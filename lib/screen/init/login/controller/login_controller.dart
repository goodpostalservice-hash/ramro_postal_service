import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/resource/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../base/base_controller.dart';
import '../../../../core/error/toast.dart';
import '../../../../core/network/network_dio.dart';
import '../../opt/screen/otp.dart';
import '../model/login_response_model.dart';
import 'package:dio/dio.dart' as dio;

class LoginController extends BaseController {
  final isToLoadMore = false.obs;
  var showPassword = false.obs;

  final isPasswordVisible = true.obs;
  // var showPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentPosition();
  }

  Future<void> getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
    ].request();
    getCurrentLocation();
  }

  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checking if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Checking the location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Requesting permission if it is denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    // Handling the case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Getting the current position of the user
    Position position = await Geolocator.getCurrentPosition();
    AppVariable.current_latitude = position.latitude;
    AppVariable.current_longitude = position.longitude;
    return position;
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    AppVariable.current_latitude = position.latitude;
    AppVariable.current_longitude = position.longitude;
    return position;
  }

  Future<String?> getPublicIp() async {
    try {
      final response = await Dio().get('https://api.ipify.org?format=json');
      return response.data['ip'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  loadProductData(String phone, context) async {
    isToLoadMore.value = true;

    try {
      var map = {
        'country_code': '977',
        "phone": phone,
        "current_latitude": AppVariable.current_latitude,
        "current_longitude": AppVariable.current_longitude,
        "ip_address": await getPublicIp(),
      };

      final result = await restClient.request(
        ApiConstant.login,
        Method.POST,
        map,
      );
      if (result != null) {
        if (result is dio.Response) {
          var responseData = LoginResponse.fromJson(result.data);
          if (responseData.success == true) {
            if (responseData.data!.user!.isPhoneVerified == 0) {
              OTPScreen.phone = phone;
              Get.offNamed('/otp');
              showSuccessMessage(responseData.message);
            } else {
              AppConstant.logInfo = [];
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();

              AppConstant.bearerToken = responseData.data!.token!;
              final Map<String, dynamic> map = result.data;
              await prefs.setString('key', json.encode(map));

              // Reflect in memory list
              AppConstant.logInfo.add(result.data);

              showSuccessMessage(responseData.message);
              Get.offNamed('/dashboard');
            }
            isToLoadMore.value = false;
          } else {
            isToLoadMore.value = false;
            showErrorMessage(responseData.message);
          }
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception catch (e) {
      isToLoadMore.value = false;
      showErrorMessage('Login credential error');
    }
  }
}

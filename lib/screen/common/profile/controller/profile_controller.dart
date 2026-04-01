import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/app/core/utils/storage_util.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../base/base_controller.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/network/network_dio.dart';
import '../model/profile_response_model.dart';
import '../model/profile_update_response_model.dart';

class ProfileController extends BaseController {
  Rx<ProfileResponseModel> resultList = ProfileResponseModel().obs;
  var isToLoadMore = true.obs;
  final RxBool notifEnabled = false.obs;
  final RxBool locationEnabled = true.obs;
  final isButtonVisible = true.obs;

  final isUpdateLoading = false.obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    loadUserProfile();
  }

  void handleClick() {
    if (isButtonVisible.value == true) {
      isButtonVisible.value = false;
    } else {
      isButtonVisible.value = true;
    }
  }

  loadUserProfile() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.profile,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value
          var responseData = ProfileResponseModel.fromJson(result.data);
          resultList.value = responseData;

          // set value
          firstNameController.text = resultList.subject.value!.firstName
              .toString();
          lastNameController.text = resultList.subject.value!.lastName
              .toString();
          emailController.text = resultList.subject.value!.email.toString();
          phoneController.text = resultList.subject.value!.phone.toString();

          isToLoadMore.value = false;
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception {
      isToLoadMore.value = false;
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      // showErrorMessage(
      //     'Something went wrong while fetching data. Try again later.');
    }
  }

  updateUserProfile(
    String firstName,
    String lastName,
    String email,
    String address,
    String dob,
  ) async {
    isUpdateLoading.value = true;

    final map = <String, dynamic>{
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "address": address,
      "date_of_birth": dob,
      "phone": phoneController.text.toString(),
    };

    try {
      final result = await restClient.request(
        ApiConstant.updateProfile,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = ProfileUpdateResponseModel.fromJson(result.data);

          if (responseData.success == true) {
            isUpdateLoading.value = false;
            isButtonVisible.value = false;
            await loadUserProfile();
            showSuccessMessage(responseData.message.toString());
          } else {
            isUpdateLoading.value = false;
            showErrorMessage(responseData.message.toString());
          }

          handleClick();
        }
      } else {
        isUpdateLoading.value = false;
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      isUpdateLoading.value = false;
      showErrorMessage('Something went wrong while update. Try again later.');
    }
  }

  deleteAccount() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.deleteProfile,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = ProfileUpdateResponseModel.fromJson(result.data);

          if (result.data['success'] == true) {
            showSuccessMessage(result.data['message']);
            Get.offNamed('/login');
          } else {
            showErrorMessage('Failed to delete your account.');
          }
        }
      } else {}
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');

      showErrorMessage('Something went wrong while update. Try again later.');
    }
  }

  logOut() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.logout,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          if (result.statusCode == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // clear all the values for sharedpreferences
            prefs.clear();
            AppConstant.logInfo.clear();
            AppConstant.bearerToken = "";
            SStorageUtil.deleteAuthData();
            AppConstant.logInfo.clear();
            Get.toNamed("/login");
            showSuccessMessage("Logged Out");
          } else {
            showErrorMessage("Failed to logout.");
          }
        }
      } else {}
    } on Exception catch (e) {
      print(e.toString());
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      showErrorMessage('Something went wrong while update. Try again later.');
    }
  }
}

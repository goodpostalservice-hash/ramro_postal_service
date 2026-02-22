import 'package:get/get.dart';
import '../../../../../base/base_controller.dart';
import '../../../../../core/constants/api_constant.dart';
import '../../../../../core/error/toast.dart';
import '../../../../../core/network/network_dio.dart';
import '../model/update_password_response_model.dart';
import 'package:dio/dio.dart' as dio;

class UpdatePasswordController extends BaseController {

  final isToLoadMore = false.obs;
  final isObscureText = true.obs;
  var showPassword = false.obs;

  void updateObscure() {
    if (isObscureText.value == true) {
      isObscureText.value = false;
    } else {
      isObscureText.value = true;
    }
  }

  requestForgetPassword(String oldPassword, String password) async {

    isToLoadMore.value = true;

    try {
      final map = {
        'old_password': oldPassword,
        'password' : password
      };

      final result = await restClient.request(
          ApiConstant.updatePassword, Method.POST, map
      );

      if (result != null) {
        if (result is dio.Response) {

          var responseData = UpdatePasswordResponseModel.fromJson(result.data);
          if (responseData.success == true) {
            showSuccessMessage(responseData.message.toString());
            isToLoadMore.value = false;
            // Get.off(()=>DashboardScreen());
            Get.back();
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
      isToLoadMore.value = false;
      showErrorMessage('Failed. Try again later.');
    }
  }
}

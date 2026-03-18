import 'package:get/get.dart';
import '../../../../../../base/base_controller.dart';
import '../../../../../../core/constants/api_constant.dart';
import '../../../../../../core/error/toast.dart';
import '../../../../../../core/network/network_dio.dart';
import '../../../login/presentation/pages/login.dart';
import '../model/send_otp_response_model.dart';
import 'package:dio/dio.dart' as dio;

class ChangeForgetPasswordController extends BaseController {

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

  requestForgetPassword(String phone, String password) async {

    isToLoadMore.value = true;

    try {
      final map = {
        'phone': phone,
        'password' : password
      };

      print(map.toString());

      final result = await restClient.request(
          ApiConstant.changeForgetPassword, Method.POST, map
      );

      if (result != null) {
        if (result is dio.Response) {

          var responseData = SendOTPResponseModel.fromJson(result.data);

          if (responseData.success == true) {
            showSuccessMessage(responseData.message.toString());
            isToLoadMore.value = false;
            Get.offAll(LoginScreen());
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
      // Get.offAllNamed('/password');
      isToLoadMore.value = false;
      showErrorMessage('Otp request failed. Try again later');
    }
  }
}

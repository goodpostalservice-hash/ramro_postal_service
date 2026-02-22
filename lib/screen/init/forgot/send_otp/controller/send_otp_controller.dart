import 'package:get/get.dart';
import '../../../../../base/base_controller.dart';
import '../../../../../core/constants/api_constant.dart';
import '../../../../../core/error/toast.dart';
import '../../../../../core/network/network_dio.dart';
import '../../verify_otp/presentation/pages/verify_forget_otp_screen.dart';
import '../model/send_otp_response_model.dart';
import 'package:dio/dio.dart' as dio;

class SendOTPController extends BaseController {
  final isToLoadMore = false.obs;
  var showPassword = false.obs;

  requestForgetPassword(String phone) async {
    isToLoadMore.value = true;

    try {
      final map = {'phone': "977$phone"};

      final result = await restClient.request(
          ApiConstant.forgetPassword, Method.POST, map);

      if (result != null) {
        if (result is dio.Response) {
          var responseData = SendOTPResponseModel.fromJson(result.data);

          if (responseData.success == true) {
            VerifyForgetOTPScreen.phone = phone;
            Get.offNamed('/verifyForgetOTP');

            // PasswordScreen.phone = phone;
            //
            // if (responseData.message.toString().toLowerCase() == 'Your Phone is already verified'.toLowerCase()) {
            //   // redirect to main screen
            // } else {
            //   // navigate the screen to verify an opt
            //   OTPScreen.phone = phone;
            //   Get.offNamed('/otp');
            //   showSuccessMessage(responseData.message.toString());
            // }
            isToLoadMore.value = false;
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

import 'package:get/get.dart';
import '../../../../../../base/base_controller.dart';
import '../../../../../../core/constants/api_constant.dart';
import '../../../../../../core/error/toast.dart';
import '../../../../../../core/network/network_dio.dart';
import '../../change _password/presentation/pages/change_forget_password_screen.dart';
import '../model/send_otp_response_model.dart';
import 'package:dio/dio.dart' as dio;

class VerifyForgetOTPController extends BaseController {
  final isToLoadMore = false.obs;
  var showPassword = false.obs;

  requestForgetPassword(String phone, String otp) async {
    isToLoadMore.value = true;

    try {
      final map = {'phone': phone, 'otp': otp};

      final result = await restClient.request(
        ApiConstant.verifyForgetOTP,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          var responseData = SendOTPResponseModel.fromJson(result.data);

          if (responseData.success == true) {
            ChangeForgetPasswordScreen.phone = phone;

            Get.toNamed('/changePassword');
            showSuccessMessage(responseData.message.toString());
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

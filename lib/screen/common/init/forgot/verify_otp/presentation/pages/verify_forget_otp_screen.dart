import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../../core/error/toast.dart';
import '../../../../../../../resource/color.dart';
import '../../controller/verify_forget_otp_controller.dart';

class VerifyForgetOTPScreen extends GetView<VerifyForgetOTPController> {
  static String phone = '';

  final formKey = GlobalKey<FormState>();
  final TextEditingController _fieldOne = TextEditingController();

  VerifyForgetOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.normalBG,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.blackBold, size: 28.0),
        ),
        backgroundColor: AppColors.normalBG,
        centerTitle: true,
        title: Image.asset("assets/icons/logo.png", width: 160.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),

                info(),

                // Container(
                //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                //   alignment: Alignment.centerLeft,
                //   child: Text('We have sent you an otp at your ${VerifyForgetOTPScreen.phone}. Please enter your otp to reset your password.',
                //     style: const TextStyle(color: Colors.black87, fontSize: 15.0, fontWeight: FontWeight.normal
                //   ), textAlign: TextAlign.center,),
                // ),
                otp(),

                button(),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otp() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      height: 55.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _fieldOne,
              onChanged: (value) {
                if (value.length == 6) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black54,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.borderColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Obx(
      () => ElevatedButton(
        onPressed: () {
          controller.isToLoadMore.value = true;
          if (_fieldOne.text.length == 6) {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordScreen()));
            // controller.loadProductData('977${_phoneController.text}');
            controller.requestForgetPassword(
              VerifyForgetOTPScreen.phone,
              _fieldOne.text.toString(),
            );
            // controller.loadProductData('9779811811888');
          } else {
            showErrorMessage('Invalid phone number');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isToLoadMore.value
              ? AppColors.disabledPrimaryBtn
              : AppColors.primary,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                controller.isToLoadMore.value
                    ? 'Please wait'.toUpperCase()
                    : 'Verify OTP'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget info() {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'We have sent you an otp at your ',
              style: TextStyle(color: AppColors.lightGrey, fontSize: 15.0),
            ),
            TextSpan(
              text: VerifyForgetOTPScreen.phone,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            TextSpan(
              text: '. Please enter your otp to reset your password.',
              style: TextStyle(color: AppColors.lightGrey, fontSize: 15.0),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> delayFunction() async {
    print('Started');
    await Future.delayed(const Duration(seconds: 2));
    controller.isToLoadMore.value = false;
    print('Ended');
  }
}

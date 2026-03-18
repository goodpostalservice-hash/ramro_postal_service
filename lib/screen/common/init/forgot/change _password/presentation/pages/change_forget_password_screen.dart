import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../../core/error/toast.dart';
import '../../../../../../../resource/color.dart';
import '../../controller/change_forget_password_controller.dart';

class ChangeForgetPasswordScreen extends GetView<ChangeForgetPasswordController> {

  static String phone = '';

  final formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();

  ChangeForgetPasswordScreen({super.key});

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

                passwordWidget(),

                button(),

                const SizedBox(height: 20.0),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordWidget() {
    return Obx(() => Container(
      margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _password,
            textAlign: TextAlign.start,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            style: const TextStyle(
                fontSize: 17.0, fontWeight: FontWeight.bold
            ),
            obscureText: controller.isObscureText.value,
            decoration: InputDecoration(
              suffixIcon: controller.isObscureText.value ? IconButton(onPressed: () {controller.updateObscure();},
                  icon: const Icon(Icons.visibility_off)) : IconButton(onPressed: () {controller.updateObscure();},
                  icon: const Icon(Icons.visibility)),
              isDense: true,
              fillColor: Colors.white,
              hintText: 'New Password',
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _cpassword,
            textAlign: TextAlign.start,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            style: const TextStyle(
                fontSize: 17.0, fontWeight: FontWeight.bold
            ),
            obscureText: controller.isObscureText.value,
            decoration: InputDecoration(
              suffixIcon: controller.isObscureText.value ? IconButton(onPressed: () {controller.updateObscure();},
                  icon: const Icon(Icons.visibility_off)) : IconButton(onPressed: () {controller.updateObscure();},
                  icon: const Icon(Icons.visibility)),
              isDense: true,
              fillColor: Colors.white,
              hintText: 'Confirm Password',
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget button() {
    return Obx(() => ElevatedButton(
      onPressed: () {
        if (_password.text.toString() == _cpassword.text.toString()) {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordScreen()));
          // controller.loadProductData('977${_phoneController.text}');
          controller.isToLoadMore.value = true;
          controller.requestForgetPassword(ChangeForgetPasswordScreen.phone, _password.text.toString());
          // controller.loadProductData('9779811811888');
        } else {
          showErrorMessage('Password and confirm password must be same');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.isToLoadMore.value ? AppColors.disabledPrimaryBtn : AppColors.primary,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(controller.isToLoadMore.value ? 'Please wait'.toUpperCase() : 'Update Password'.toUpperCase(), style: const TextStyle(fontSize: 15.0,
                fontWeight: FontWeight.normal, color: Colors.white))
          ],
        ),
      ),
    ));
  }

  Widget info() {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Change your password. Please enter your new password and confirm password to continue. ', style: TextStyle(
                color: AppColors.blackBold, fontSize: 15.0
            )),
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

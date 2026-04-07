import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../core/error/toast.dart';
import '../../../../../../resource/color.dart';
import '../../controller/update_password_controller.dart';

class UpdatePasswordScreen extends GetView<UpdatePasswordController> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _oldpassword = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();

  UpdatePasswordScreen({super.key});

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
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black87, fontSize: 17.0),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _oldpassword,
              textAlign: TextAlign.start,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              obscureText: controller.isObscureText.value,
              decoration: InputDecoration(
                suffixIcon: controller.isObscureText.value
                    ? IconButton(
                        onPressed: () {
                          controller.updateObscure();
                        },
                        icon: const Icon(Icons.visibility_off),
                      )
                    : IconButton(
                        onPressed: () {
                          controller.updateObscure();
                        },
                        icon: const Icon(Icons.visibility),
                      ),
                isDense: true,
                fillColor: Colors.white,
                hintText: 'Old Password',
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
            const SizedBox(height: 7.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _password,
              textAlign: TextAlign.start,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              obscureText: controller.isObscureText.value,
              decoration: InputDecoration(
                suffixIcon: controller.isObscureText.value
                    ? IconButton(
                        onPressed: () {
                          controller.updateObscure();
                        },
                        icon: const Icon(Icons.visibility_off),
                      )
                    : IconButton(
                        onPressed: () {
                          controller.updateObscure();
                        },
                        icon: const Icon(Icons.visibility),
                      ),
                isDense: true,
                fillColor: Colors.white,
                hintText: 'New Password',
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
            const SizedBox(height: 7.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _cpassword,
              textAlign: TextAlign.start,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              obscureText: controller.isObscureText.value,
              decoration: InputDecoration(
                suffixIcon: controller.isObscureText.value
                    ? IconButton(
                        onPressed: () {
                          controller.updateObscure();
                        },
                        icon: const Icon(Icons.visibility_off),
                      )
                    : IconButton(
                        onPressed: () {
                          controller.updateObscure();
                        },
                        icon: const Icon(Icons.visibility),
                      ),
                isDense: true,
                fillColor: Colors.white,
                hintText: 'Confirm Password',
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
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Obx(
      () => ElevatedButton(
        onPressed: () {
          if (_password.text.length >= 6 && _cpassword.text.length >= 6) {
            if (_oldpassword.text.isNotEmpty &&
                _password.text.isNotEmpty &&
                _cpassword.text.isNotEmpty) {
              if (_password.text.toString() == _cpassword.text.toString()) {
                controller.isToLoadMore.value = true;
                controller.requestForgetPassword(
                  _oldpassword.text.toString(),
                  _password.text.toString(),
                );
              } else {
                showErrorMessage('Password and confirm password must be same');
              }
            } else {
              showErrorMessage('All fields are mandatory');
            }
          } else {
            showErrorMessage('Password must be 6 digits or more');
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
                    : 'Update Password'.toUpperCase(),
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
}

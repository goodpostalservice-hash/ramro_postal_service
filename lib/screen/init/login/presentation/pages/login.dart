import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/custom_text_styles.dart';
import 'package:ramro_postal_service/core/themes/theme_helper.dart';
import 'package:ramro_postal_service/core/widgets/custom_button.dart';
import 'package:ramro_postal_service/core/widgets/custom_text_field.dart';
import 'package:ramro_postal_service/resource/data.dart';
import 'package:ramro_postal_service/screen/init/login/controller/login_controller.dart';
import 'package:ramro_postal_service/screen/init/opt/screen/otp.dart';
import '../../../../../resource/color.dart';

class LoginScreen extends GetView<LoginController> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.showDisclosure();
    Map<String, dynamic>? userData;
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: AppBar(
        elevation: 0,
        // leading: IconButton(
        //   onPressed: () {  },
        //   icon: Icon(Icons.close, color: AppColors.blackBold, size: 28.0),
        // ),
        backgroundColor: appTheme.gray25,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("assets/icons/logo.png", width: 200.0),
                const SizedBox(height: 60.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Continue with phone',
                    style: CustomTextStyles.titleSmall,
                  ),
                ),
                CustomTextFormField(
                  controller: _phoneController,
                  onChanged: (value) {
                    if (value.length == 10) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                button(context),
                // if (Platform.isIOS)
                //   SignInWithAppleButton(
                //     onPressed: () async {
                //       final credential =
                //           await SignInWithApple.getAppleIDCredential(
                //         scopes: [
                //           AppleIDAuthorizationScopes.email,
                //           AppleIDAuthorizationScopes.fullName,
                //         ],
                //       );
                //       String base64EncodedString =
                //           credential.identityToken!.split('.')[1];

                //       // Calculate the number of padding characters needed
                //       int paddingNeeded = 4 - (base64EncodedString.length % 4);

                //       // Add padding characters to the Base64 string
                //       for (int i = 0; i < paddingNeeded; i++) {
                //         base64EncodedString += "=";
                //       }

                //       // Decode the Base64-encoded string
                //       List<int> decodedBytes =
                //           base64.decode(base64EncodedString);

                //       // Convert the decoded bytes to a string
                //       String decodedString = utf8.decode(decodedBytes);

                //       // Parse the JSON string into a Dart object
                //       Map<String, dynamic> decodedJson =
                //           json.decode(decodedString);

                //       userData = {
                //         'id': credential.authorizationCode,
                //         'token': credential.identityToken,
                //         'email': decodedJson["email"]
                //       };
                //       print(credential);
                //       print(jsonEncode(userData));
                //       final googleSignInController =
                //           Get.put(GoogleSignInController());
                //       googleSignInController.signInWithApple(
                //           context, userData?['email']);

                //       // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                //       // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                //     },
                //   ),
                const SizedBox(height: 10.0),
                const SizedBox(height: 30.0),
                InkWell(
                  onTap: () {
                    Get.toNamed('/register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        "Sign up ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                policy(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownCountry() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.borderColor, width: 1.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 7.0, right: 7.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  ListData.countryList[0]['flag'].toString(),
                  height: 30.0,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5.0, right: 10.0),
            width: 1.0,
            height: 30.0,
            color: AppColors.fieldHint,
          ),
          Text(
            ListData.countryList[0]['country_code'].toString(),
            style: TextStyle(
              color: AppColors.blackBold,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SizedBox(
              width: 185.0,
              child: TextFormField(
                controller: _phoneController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 10) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                style: TextStyle(
                  color: AppColors.blackBold,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'XXXXXXXXXX',
                  hintStyle: TextStyle(
                    color: AppColors.fieldHint,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(context) {
    return Obx(
      () => AppButton(
        label: 'Continue',
        loadingText: 'Please Wait',
        onPressed: () {
          OTPScreen.phone = '977${_phoneController.text}';
          if (formKey.currentState!.validate()) {
            controller.loadProductData(_phoneController.text, context);
          }
        },
        isLoading: controller.isToLoadMore.value,
      ),
    );
  }

  Widget continueWithFacebook() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.facebookBtn),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        margin: const EdgeInsets.all(0.0),
        height: 50.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 25.0),
              child: Icon(
                Icons.facebook_sharp,
                color: Colors.white,
                size: 38.0,
              ),
            ),
            SizedBox(width: 20.0),
            Text(
              'Continue with Facebook',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget policy() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'By continuing, I agree with the ',
                style: CustomTextStyles.bodyMediumGray600,
              ),
              TextSpan(
                text: 'privacy policy/ Term & Conditions',
                style: CustomTextStyles.titleSmallBlack,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
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

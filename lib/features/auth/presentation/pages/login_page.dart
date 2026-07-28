import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ramro_postal_service/core/resource/data.dart';
import '../../../../core/services/device_helper.dart';
import '../../data/models/login_request.dart';

class LoginScreen extends GetView<AuthController> {
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: AppSpacing.only(top: AppSpacing.epic + AppSpacing.epic),
          padding: AppSpacing.cardInsets,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(AppAssets.iconsLogo, width: AppSizes.logoLogin),
                const SizedBox(height: AppSpacing.epic),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Continue with phone',
                    style: CustomTextStyles.titleSmall,
                  ),
                ),
                CustomTextFormField(
                  controller: controller.phoneController,
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
      padding: AppSpacing.all(AppSpacing.sm + AppSpacing.xxs),
      margin: AppSpacing.only(top: AppSpacing.sm, bottom: AppSpacing.xxl),
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: AppRadius.circular(AppRadius.sm),
        border: Border.all(color: appTheme.gray200, width: 1.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: AppSpacing.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: <Widget>[
                Image.asset(
                  ListData.countryList[0]['flag'].toString(),
                  height: AppSizes.avatarSm,
                ),
              ],
            ),
          ),
          Container(
            margin: AppSpacing.only(left: AppSpacing.xs, right: AppSpacing.sm),
            width: 1.0,
            height: AppSizes.avatarSm,
            color: appTheme.gray400,
          ),
          Text(
            ListData.countryList[0]['country_code'].toString(),
            style: TextStyle(
              color: appTheme.black,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: AppSpacing.symmetric(horizontal: AppSpacing.sm),
            child: SizedBox(
              width: 185.0,
              child: TextFormField(
                controller: controller.phoneController,
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
                  color: appTheme.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'XXXXXXXXXX',
                  hintStyle: TextStyle(
                    color: appTheme.gray400,
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
        onPressed: () async {
          // OTPScreen.phone = '977${_phoneController.text}';
          final deviceData = await DeviceHelper.getDeviceData();
          if (formKey.currentState!.validate()) {
            final request = LoginRequest(
              phone: controller.phoneController.text.trim(),
              countryCode: '977',
              currentLatitude: '27.223',
              currentLongitude: '89.66',
              ipAddress: deviceData['ip_address'],
              macAddress: deviceData['device_id'],
            );

            controller.login(request);
          }
        },
        isLoading: controller.isLoading.value,
        borderRadius: AppSpacing.md,
      ),
    );
  }

  Widget continueWithFacebook() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: appTheme.black),
      child: Container(
        padding: AppSpacing.all(AppSpacing.none),
        margin: AppSpacing.all(AppSpacing.none),
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(borderRadius: AppRadius.buttonRadius),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: AppSpacing.only(
                left: AppSpacing.sm,
                right: AppSpacing.xxl,
              ),
              child: Icon(
                Icons.facebook_sharp,
                color: appTheme.white,
                size: AppSizes.iconXl + AppSpacing.xs,
              ),
            ),
            AppSpacing.horizontalGapXl,
            Text(
              'Continue with Facebook',
              style: CustomTextStyles.bodyLargeButton500,
            ),
          ],
        ),
      ),
    );
  }

  Widget policy() {
    return Container(
      padding: AppSpacing.only(top: AppSpacing.xl),
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
    controller.isLoading.value = false;
    print('Ended');
  }
}

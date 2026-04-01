import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/screen/common/init/splash_controller.dart';
import 'package:ramro_postal_service/screen/common/no_internet/no_internet_controller.dart';
import '../../../app/core/utils/storage_util.dart';
import '../../../manager/userdata.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late double width, height;
  late AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animationController.repeat(reverse: true);

    navigateScreen();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    Get.put(NoInternetController());

    return Scaffold(
      backgroundColor: AppColors.normalBG,
      body: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Align(
            child: ScaleTransition(
              scale: Tween(begin: 0.6, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: const Image(
                image: AssetImage('assets/icons/logo.png'),
                width: 180.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateScreen() async {
    Timer(const Duration(seconds: 3), () async {
      // get saved user json data
      var userInfo = await ReceiverService.getUserLog();

      userInfo != null ? AppConstant.logInfo.add(userInfo) : null;

      // to check current location and send user statistics.
      var splash = SplashController();
      bool isSucceed = await splash.determinePosition();

      if (isSucceed == true) {
        if (AppConstant.logInfo.toString() == '[]') {
          // Get.offNamed('/dashboard');
          Get.offNamed('/login');
        } else {
          AppConstant.bearerToken = AppConstant.logInfo[0]['data']['token']
              .toString();
          SStorageUtil.saveAuthData(
            accessToken: AppConstant.bearerToken,
            refreshToken: "",
          );
          Get.offNamed('/dashboard');

          // redirect to main screen
        }
      } else {
        showErrorMessage("Something got wrong! Try again later.");
      }
    });
  }
}

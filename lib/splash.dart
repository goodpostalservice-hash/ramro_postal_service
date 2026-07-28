import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/design_system/design_system.dart';
import 'package:ramro_postal_service/core/storage/secure_storage.dart';
import 'package:ramro_postal_service/core/storage/storage_util.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';

import 'core/constants/const_keys.dart';
import 'features/dashboard/presentation/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    unawaited(_navigateScreen());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white,
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.6, end: 1).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: const Image(
            image: AssetImage(AppAssets.iconsLogo),
            width: AppSizes.logoSplash,
          ),
        ),
      ),
    );
  }

  bool shouldGoToDashboard({
    required bool isLoggedIn,
    required String? accessToken,
    required String? userType,
  }) {
    return isLoggedIn &&
        (accessToken ?? '').trim().isNotEmpty &&
        (userType ?? '').trim().isNotEmpty;
  }

  Future<void> _navigateScreen() async {
    final SplashController splashController =
        Get.isRegistered<SplashController>()
        ? Get.find<SplashController>()
        : Get.put(SplashController());

    try {
      await Future.wait<void>([
        Future<void>.delayed(const Duration(seconds: 2)),
        splashController.determinePosition().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint(
              'Location determination timed out, continuing navigation...',
            );
            return false;
          },
        ),
      ]);
    } catch (e) {
      debugPrint('Error during splash initialization: $e');
    }

    if (!mounted) return;

    final nextRoute = await _resolveNextRoute();
    if (mounted) {
      Get.offAllNamed(nextRoute);
    }
  }

  Future<String> _resolveNextRoute() async {
    final isWelcomed =
        SStorageUtil.getData<bool>(key: SConstKeys.isWelcomed) == true;

    try {
      final isLoggedIn =
          SStorageUtil.getData<bool>(key: SConstKeys.isLoggedIn) == true;

      final secureStorage = Get.find<SecureStorageService>();
      final accessToken = await secureStorage.getAccessToken();

      final userData = SStorageUtil.getUserData();
      final userType = userData?.userType;

      final hasRestorableSession = shouldGoToDashboard(
        isLoggedIn: isLoggedIn,
        accessToken: accessToken,
        userType: userType,
      );

      if (hasRestorableSession) {
        return AppRoutes.dashboard;
      }

      if (isLoggedIn) {
        await SStorageUtil.saveData(key: SConstKeys.isLoggedIn, value: false);
      }
    } catch (error) {
      debugPrint('Error determining next route: $error');
    }

    return isWelcomed ? AppRoutes.selectRole : AppRoutes.onBoarding;
  }
}

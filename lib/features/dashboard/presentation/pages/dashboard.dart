import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/notification/presentation/pages/notification_page.dart';
import '../../../address/presentation/pages/saved_address_screen.dart';
import '../../../common/presentation/pages/side_menu.dart';
import '../../../home/presentation/pages/home_map_screen.dart';
import '../../../qr/presentation/pages/qr_scanner_page.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  // bottom navigation bar
  int currentTab = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentTab = index;
      switch (index) {
        case 0:
          currentScreen = const HomeMapScreen();
          break;
        case 1:
          currentScreen = const NotificationScreen();
          break;
        case 2:
          currentScreen = const SavedAddressScreen();
          break;
        default:
          currentScreen = const MenuScreen();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // need permission for location
    getPermission();
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeMapScreen();
  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(
        () => Scaffold(
          body: PageStorage(bucket: bucket, child: currentScreen),
          bottomNavigationBar: dashboardController.showBottomNav.value
              ? BottomAppBar(
                  elevation: 2,
                  shape: const CircularNotchedRectangle(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.white,
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.gray500.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(
                            0,
                            3,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    height: AppSizes.bottomNavigationHeight + AppSpacing.lg,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            padding: AppSpacing.all(AppSpacing.none),
                            minWidth: 0,
                            onPressed: () => _onItemTapped(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  AppAssets.iconsSvgHome,
                                  height: AppSizes.iconLg,
                                  width: AppSizes.iconLg,
                                  color: currentTab == 0
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                AppSpacing.gapXs,
                                Text(
                                  'Home'.toUpperCase(),
                                  style: currentTab == 0
                                      ? CustomTextStyles.bodySmallOrange12_400
                                      : CustomTextStyles.bodySmallBlack12_400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            padding: AppSpacing.all(AppSpacing.none),
                            minWidth: 0,
                            onPressed: () async {
                              _onItemTapped(2);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  AppAssets.iconsSvgSaved,
                                  height: AppSizes.iconLg,
                                  width: AppSizes.iconLg,
                                  color: currentTab == 2
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                const SizedBox(height: AppSpacing.none),
                                FittedBox(
                                  child: Text(
                                    'Saved'.toUpperCase(),
                                    maxLines: 1,
                                    style: currentTab == 2
                                        ? CustomTextStyles.bodySmallOrange12_400
                                        : CustomTextStyles.bodySmallBlack12_400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            padding: AppSpacing.all(AppSpacing.none),
                            minWidth: 0,
                            onPressed: () {
                              setState(() {
                                _onItemTapped(5);
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AppSpacing.gapXxl,
                                Text(
                                  'Scan'.toUpperCase(),
                                  style: currentTab == 5
                                      ? CustomTextStyles.bodySmallOrange12_400
                                      : CustomTextStyles.bodySmallBlack12_400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            padding: AppSpacing.all(AppSpacing.none),
                            minWidth: 0,
                            onPressed: () {
                              _onItemTapped(1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  AppAssets.iconsSvgNotification,
                                  height: AppSizes.iconLg,
                                  width: AppSizes.iconLg,
                                  color: currentTab == 1
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                AppSpacing.gapXs,
                                Text(
                                  'Notification'.toUpperCase(),
                                  style: currentTab == 1
                                      ? CustomTextStyles.bodySmallOrange12_400
                                      : CustomTextStyles.bodySmallBlack12_400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            padding: AppSpacing.all(AppSpacing.none),
                            minWidth: 0,
                            onPressed: () {
                              setState(() {
                                _onItemTapped(3);
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  AppAssets.iconsSvgSettings,
                                  height: AppSizes.iconLg,
                                  width: AppSizes.iconLg,
                                  color: currentTab == 3
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                AppSpacing.gapXs,
                                Text(
                                  'More'.toUpperCase(),
                                  style: currentTab == 3
                                      ? CustomTextStyles.bodySmallOrange12_400
                                      : CustomTextStyles.bodySmallBlack12_400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: dashboardController.showBottomNav.value
              ? FloatingActionButton(
                  heroTag: true,
                  backgroundColor: appTheme.orangeBase,
                  elevation: 0,
                  onPressed: () {
                    // replace with GetX navigator
                    Navigator.push(
                      context,
                      PageRouteBuilder<void>(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const QRScannerPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    AppAssets.iconsSvgQrCode,
                    height: AppSizes.iconLg,
                    width: AppSizes.iconLg,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            insetPadding: AppSpacing.all(AppSpacing.sm + AppSpacing.xxs),
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(exit(0)),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
    ].request();
    // _getCurrentLocation();
  }

  // _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     AppVariable.current_latitude = position.latitude;
  //     AppVariable.current_longitude = position.longitude;
  //   });
  //   getCurrentLocationName(position.latitude, position.longitude);
  // }
}

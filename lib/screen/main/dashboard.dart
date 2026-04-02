import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/driver_home_map_screen.dart';
import 'package:ramro_postal_service/screen/main/controller/dashboard_controller.dart';
import 'package:ramro_postal_service/screen/main/notification/controller/notification_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/presentation/pages/saved_address_screen.dart';
import '../../resource/variable.dart';
import '../scanner/presentation/view/new_scanner.dart';
import 'notification/presentation/pages/notification_home.dart';
import 'side_menu.dart';

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
          currentScreen = const DriverHomeMapScreen();
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
  Widget currentScreen = const DriverHomeMapScreen();
  final dashboardController = Get.put(DashboardController());

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
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(
                            0,
                            3,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            minWidth: 0,
                            onPressed: () => _onItemTapped(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/svg/home.svg",
                                  height: getSize(22.0),
                                  width: getSize(22.0),
                                  color: currentTab == 0
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                const SizedBox(height: 4.0),
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
                            padding: const EdgeInsets.all(0),
                            minWidth: 0,
                            onPressed: () async {
                              _onItemTapped(2);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/svg/saved.svg",
                                  height: getSize(22.0),
                                  width: getSize(22.0),
                                  color: currentTab == 2
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                const SizedBox(height: 0.0),
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
                            padding: const EdgeInsets.all(0),
                            minWidth: 0,
                            onPressed: () {
                              setState(() {
                                _onItemTapped(5);
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 24.0),
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
                            padding: const EdgeInsets.all(0),
                            minWidth: 0,
                            onPressed: () {
                              Get.put(NotificationController());
                              _onItemTapped(1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/svg/notification.svg",
                                  height: getSize(22.0),
                                  width: getSize(22.0),
                                  color: currentTab == 1
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                const SizedBox(height: 4.0),
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
                            padding: const EdgeInsets.all(0),
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
                                  "assets/icons/svg/settings.svg",
                                  height: getSize(22.0),
                                  width: getSize(22.0),
                                  color: currentTab == 3
                                      ? appTheme.orangeBase
                                      : appTheme.black,
                                ),
                                const SizedBox(height: 4.0),
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
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  onPressed: () {
                    // replace with GetX navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerPage(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/icons/svg/Qr_Code.svg",
                    height: getSize(24.0),
                    width: getSize(24.0),
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
            insetPadding: const EdgeInsets.all(10),
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

  Future<void> getCurrentLocationName(double latitude, double longitude) async {
    final pinURL =
        "https://easytaxinepal.com/nominatim/reverse?format=json&lat=$latitude&lon=$longitude&zoom=16&addressdetails=1";
    var dio = Dio();
    final response = await dio
        .get(pinURL, options: Options(headers: {}))
        .catchError((error, stackTrace) {
          log("Error Data: $error");
        });

    final responseData = response.data;
    setState(() {
      AppVariable.pick_location = responseData['display_name'].toString();
    });
  }
}

// class DashboardScreen extends StatefulWidget {
//
//   static late bool boolValue;
//
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
//   // navigation drawer
//   late AnimationController controller;
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int currentTab = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//
//     getPermission();
//   }
//
//   // final List<Widget> screens = [
//   //   // HomeScreen(),
//   //   HomeMapScreen(),
//   //   NotificationHomeScreen(),
//   //   // HistoryScreen(),
//   //   MyQRScreen(),
//   //   MenuScreen()
//   // ];
//
//   final List<Widget> screens = [
//     HomeMapScreen(),
//     NotificationHomeScreen(),
//     MyQRScreen(),
//     MenuScreen()
//   ];
//
//
//   final PageStorageBucket bucket = PageStorageBucket();
//   // Widget currentScreen = HomeScreen();
//   Widget currentScreen = HomeMapScreen();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         key: _scaffoldKey,
//         body: PageStorage(
//           child: currentScreen,
//           bucket: bucket,
//         ),
//         bottomNavigationBar: BottomAppBar(
//           elevation: 2,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//             ),
//             height: 60,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: MaterialButton(
//                     padding: EdgeInsets.all(0),
//                     minWidth: 0,
//                     onPressed: () {
//                       setState(() {
//                         // currentScreen = HomeScreen();
//                         currentScreen = HomeMapScreen();
//                         currentTab = 0;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset("assets/icons/ic_bnv_home.png", height: 20.0, color: currentTab == 0 ?
//                         AppColors.primary : AppColors.lightGrey),
//                         SizedBox(
//                           height: 4.0,
//                         ),
//                         Text(
//                           'Home'.toUpperCase(),
//                           style: TextStyle(
//                             color: currentTab == 0 ? AppColors.primary : AppColors.lightGrey, fontSize: 11.0, fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: MaterialButton(
//                     padding: EdgeInsets.all(0),
//                     minWidth: 0,
//                     onPressed: () {
//                       Get.put(NotificationController());
//                       setState(() {
//                         currentScreen =
//                             NotificationHomeScreen(); // if user taps on this Home tab will be active
//                         currentTab = 1;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset("assets/icons/ic_bnv_inbox.png", height: 20.0, color: currentTab == 1 ?
//                         AppColors.primary : AppColors.lightGrey),
//                         SizedBox(
//                           height: 4.0,
//                         ),
//                         Text(
//                           'Notice'.toUpperCase(),
//                           style: TextStyle(
//                             color: currentTab == 1 ? AppColors.primary : AppColors.lightGrey, fontSize: 11.0, fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: MaterialButton(
//                     padding: EdgeInsets.all(0),
//                     minWidth: 0,
//                     onPressed: () {
//                       Get.put(MyQRController());
//                       setState(() {
//                         currentScreen = MyQRScreen(); // if user taps on this Home tab will be active
//                         currentTab = 2;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Icon(Icons.qr_code_outlined, size: 25.0, color: currentTab == 2 ?
//                         AppColors.primary : AppColors.lightGrey),
//                         // Image.asset("assets/icons/ic_bnv_history.png", height: 20.0, color: currentTab == 2 ?
//                         // AppColors.primary : AppColors.lightGrey),
//                         SizedBox(
//                           height: 0.0,
//                         ),
//                         Text(
//                           'My QR'.toUpperCase(),
//                           style: TextStyle(
//                             color: currentTab == 2 ? AppColors.primary : AppColors.lightGrey, fontSize: 11.0, fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: MaterialButton(
//                     padding: EdgeInsets.all(0),
//                     minWidth: 0,
//                     onPressed: () {
//                       setState(() {
//                         currentScreen =
//                             MenuScreen(); // if user taps on this Home tab will be active
//                         currentTab = 3;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset("assets/icons/ic_bnv_more.png", height: 20.0, color: currentTab == 3 ?
//                         AppColors.primary : AppColors.lightGrey),
//                         SizedBox(
//                           height: 4.0,
//                         ),
//                         Text(
//                           'More'.toUpperCase(),
//                           style: TextStyle(
//                             color: currentTab == 3 ? AppColors.primary : AppColors.lightGrey, fontSize: 11.0, fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         insetPadding: EdgeInsets.all(10),
//         title: Text('Are you sure?'),
//         content: Text('Do you want to exit an App'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(exit(0)),
//             child: Text('Yes'),
//           ),
//         ],
//       ),
//     )) ?? false;
//   }
//
//   Future<void> getPermission() async {
//     Map<Permission, PermissionStatus> statuses = await [
//     Permission.location, Permission.storage,
//       Permission.camera
//     ].request();
//     _getCurrentLocation();
//   }
//
//   _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     if (position != null) {
//       setState(() {
//         AppVariable.current_latitude = position.latitude;
//         AppVariable.current_longitude = position.longitude;
//       });
//     }
//     getCurrentLocationName( position.latitude, position.longitude);
//   }
//
//   Future<void> getCurrentLocationName(double latitude, double longitude) async {
//     final pinURL = "https://easytaxinepal.com/nominatim/reverse?format=json&lat="+latitude.toString()+"&lon="+longitude.toString()+"&zoom=16&addressdetails=1";
//     var dio = Dio();
//     final response = await dio.get(pinURL,
//       options: Options(
//         headers: {
//         },
//       ),
//     ).catchError((error, stackTrace) {
//       log("Error Data: " + error.toString());
//     });
//
//     final responseData = response.data;
//     setState(() {
//       AppVariable.pick_location = responseData['display_name'].toString();
//     });
//   }
//
// }

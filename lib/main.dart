import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ramro_postal_service/app/routes/app_pages.dart';
import 'package:ramro_postal_service/core/themes/theme_helper.dart';
import 'package:ramro_postal_service/firebase_options.dart';
import 'app/core/utils/storage_util.dart';
import 'core/constants/app_constant.dart';
import 'core/network/network_dio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SStorageUtil.initStorage();
  // Platform.isAndroid
  //     ? await Firebase.initializeApp()
  //     : await Firebase.initializeApp(
  //         options: const FirebaseOptions(
  //             apiKey: 'AIzaSyAWDFvDvVl6izpEu_NdZX6pPFVJzYXNS_k',
  //             appId: 'com.rps.ramropostalservice',
  //             messagingSenderId: '229788114887',
  //             projectId: 'ramro-postal-service'));
  HttpOverrides.global = MyHttpOverrides();
  initServices();
  // WakelockPlus.enable();

  // redirect to main screen

  await initOneSignal();

  runApp(const MyApp());
}

Future<void> initOneSignal() async {
  // 1. Initialize the SDK with your app ID
  OneSignal.initialize(AppConstant.oneSignalAppId);

  OneSignal.Notifications.requestPermission(
    true, // or false if you want to show your own pre-permission UI first
  );

  // 3. Handle notifications shown while the app is in the foreground
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    // You get the full notification here
    final notification = event.notification;
    print("Notification will show in foreground: ${notification.body}");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // let content draw behind
        statusBarIconBrightness: Brightness.dark, // Android: dark icons
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: appTheme.gray25,
        systemNavigationBarDividerColor: const Color.fromARGB(0, 56, 49, 49),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}

initServices() async {
  await Get.putAsync<RestClient>(() => RestClient().init());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

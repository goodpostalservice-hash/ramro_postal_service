import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ramro_postal_service/core/themes/theme_helper.dart';
import 'package:ramro_postal_service/firebase_options.dart';
import 'package:ramro_postal_service/screen/about/view/contact.dart';
import 'package:ramro_postal_service/screen/init/forgot/send_otp/presentation/pages/send_otp_screen.dart';
import 'package:ramro_postal_service/screen/init/password/screen/binding/password_binding.dart';
import 'package:ramro_postal_service/screen/about/view/about.dart';
import 'package:ramro_postal_service/screen/about/binding/help_binding.dart';
import 'package:ramro_postal_service/screen/main/dashboard.dart';
import 'core/constants/app_constant.dart';
import 'core/network/network_dio.dart';
import 'screen/no_internet/no_internet_connection.dart';
import 'screen/add_location/binding/add_place_binding.dart';
import 'screen/add_location/view/presentation/add_missing_address_on_map_screen.dart';
import 'screen/add_location/view/presentation/add_place_screen.dart';
import 'screen/init/forgot/change _password/binding/change_forget_password_binding.dart';
import 'screen/init/forgot/change _password/presentation/pages/change_forget_password_screen.dart';
import 'screen/init/forgot/send_otp/binding/send_otp_binding.dart';
import 'screen/init/forgot/verify_otp/binding/verify_forget_otp_binding.dart';
import 'screen/init/forgot/verify_otp/presentation/pages/verify_forget_otp_screen.dart';
import 'screen/init/login/binding/login_binding.dart';
import 'screen/init/login/presentation/pages/login.dart';
import 'screen/init/opt/screen/otp.dart';
import 'screen/init/password/screen/presentation/pages/password.dart';
import 'screen/init/register/screen/register.dart';
import 'screen/init/splash.dart';
import 'screen/main/notification/binding/notification_binding.dart';
import 'screen/main/notification/presentation/pages/notification_home.dart';
import 'screen/myQR/binding/my_qr_binding.dart';
import 'screen/myQR/presentation/pages/my_qr_screen.dart';
import 'screen/profile/binding/profile_binding.dart';
import 'screen/profile/presentation/pages/profile_screen.dart';
import 'screen/saved_address/binding/saved_address_binding.dart';
import 'screen/saved_address/presentation/pages/saved_address_screen.dart';
import 'screen/update_password/binding/update_password_binding.dart';
import 'screen/update_password/presentation/pages/update_password_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/no_internet', page: () => const NoInternetConnection()),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/password',
          page: () => PasswordScreen(),
          binding: PasswordBinding(),
        ),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/otp', page: () => const OTPScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(
          name: '/myqr',
          page: () => const MyQRScreen(),
          binding: MyQRBinding(),
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileScreen(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/notification',
          page: () => const NotificationScreen(),
          binding: NotificationBinding(),
        ),

        // fotget password
        GetPage(
          name: '/sendForgetOTP',
          page: () => SendForgetOTPScreen(),
          binding: SendOTPBinding(),
        ),
        GetPage(
          name: '/verifyForgetOTP',
          page: () => VerifyForgetOTPScreen(),
          binding: VerifyForgetOTPBinding(),
        ),
        GetPage(
          name: '/changePassword',
          page: () => ChangeForgetPasswordScreen(),
          binding: ChangeForgetPasswordBinding(),
        ),
        GetPage(
          name: '/updatePassword',
          page: () => UpdatePasswordScreen(),
          binding: UppdatePasswordBinding(),
        ),
        GetPage(
          name: '/savedAddress',
          page: () => const SavedAddressScreen(),
          binding: SavedAddressBinding(),
        ),
        // GetPage(
        //   name: '/mapDirection',
        //   page: () => const MapDirectionScreen(),
        //   binding: DirectionMapBinding(),
        // ),
        GetPage(
          name: '/addPlace',
          page: () => AddPlaceScreen(),
          binding: AddPlaceBinding(),
        ),


        GetPage(
          name: '/addMissingAddressOnMap',
          page: () => const AddMissingAddressOnMapScreen(),
        ),
        GetPage(
          name: '/about',
          page: () => const AboutScreen(),
          binding: AboutBinding(),
        ),
        GetPage(name: '/contact', page: () => const ContactScreen()),
      ],
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

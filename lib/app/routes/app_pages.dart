import 'package:get/get.dart';

import '../../screen/common/about/binding/help_binding.dart';
import '../../screen/common/about/view/about.dart';
import '../../screen/common/about/view/contact.dart';
import '../../screen/common/add_location/binding/add_place_binding.dart';
import '../../screen/common/add_location/view/presentation/add_missing_address_on_map_screen.dart';
import '../../screen/common/add_location/view/presentation/add_place_screen.dart';
import '../../screen/common/init/forgot/change _password/binding/change_forget_password_binding.dart';
import '../../screen/common/init/forgot/change _password/presentation/pages/change_forget_password_screen.dart';
import '../../screen/common/init/forgot/send_otp/binding/send_otp_binding.dart';
import '../../screen/common/init/forgot/send_otp/presentation/pages/send_otp_screen.dart';
import '../../screen/common/init/forgot/verify_otp/binding/verify_forget_otp_binding.dart';
import '../../screen/common/init/forgot/verify_otp/presentation/pages/verify_forget_otp_screen.dart';
import '../../screen/common/init/login/binding/login_binding.dart';
import '../../screen/common/init/login/presentation/pages/login.dart';
import '../../screen/common/init/opt/screen/otp.dart';
import '../../screen/common/init/password/screen/binding/password_binding.dart';
import '../../screen/common/init/password/screen/presentation/pages/password.dart';
import '../../screen/common/init/register/screen/register.dart';
import '../../screen/common/init/splash.dart';
import '../../screen/common/myQR/binding/my_qr_binding.dart' show MyQRBinding;
import '../../screen/common/myQR/presentation/pages/my_qr_screen.dart';
import '../../screen/common/no_internet/no_internet_connection.dart';
import '../../screen/common/profile/binding/profile_binding.dart';
import '../../screen/common/profile/presentation/pages/profile_screen.dart';
import '../../screen/main/dashboard.dart';
import '../../screen/main/notification/binding/notification_binding.dart';
import '../../screen/main/notification/presentation/pages/notification_home.dart';
import '../../screen/saved_address/binding/saved_address_binding.dart';
import '../../screen/saved_address/presentation/pages/saved_address_screen.dart';
import '../../screen/update_password/binding/update_password_binding.dart';
import '../../screen/update_password/presentation/pages/update_password_screen.dart';
import '../modules/my_subscription/bindings/my_subscription_binding.dart';
import '../modules/my_subscription/views/my_subscription_view.dart';
import '../modules/order_detail/bindings/order_detail_binding.dart';
import '../modules/order_detail/views/order_detail_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = "/";

  static final routes = [
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),

    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/no_internet', page: () => const NoInternetConnection()),
    GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),
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
    GetPage(
      name: _Paths.MY_SUBSCRIPTION,
      page: () => const MySubscriptionView(),
      binding: MySubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
  ];
}

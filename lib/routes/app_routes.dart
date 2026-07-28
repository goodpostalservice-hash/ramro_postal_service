import 'package:get/get.dart';
import 'package:ramro_postal_service/features/address/presentation/pages/add_missing_place.dart';
import 'package:ramro_postal_service/features/address/presentation/pages/saved_address_screen.dart';
import 'package:ramro_postal_service/features/auth/presentation/pages/otp.dart';
import 'package:ramro_postal_service/features/common/presentation/bindings/common_binding.dart';
import 'package:ramro_postal_service/features/earning/presentation/pages/earning_dashboard.dart';
import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/select_role/bindings/select_role_binding.dart';
import '../features/auth/presentation/pages/select_role/views/select_role_view.dart';
import '../features/common/presentation/pages/side_menu.dart';
import '../features/dashboard/presentation/pages/dashboard.dart';
import '../features/on_boarding/on_boarding.dart';
import '../features/settings/presentation/pages/privacy_policy_screen.dart';
import '../features/settings/presentation/pages/terms_and_condition_screen.dart';
import '../splash.dart';
import '../features/home/presentation/bindings/home_binding.dart';
import '../features/home/presentation/pages/home_map_screen.dart';
import '../features/orders/presentation/pages/available_order.dart';
import '../features/orders/presentation/pages/order_detail.dart';
import '../features/orders/presentation/pages/order_history.dart';
import '../features/profile/presentation/bindings/profile_binding.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/address/presentation/bindings/address_binding.dart';
import '../features/notification/presentation/bindings/notification_binding.dart';
import '../features/notification/presentation/pages/notification_page.dart';
import '../features/qr/presentation/bindings/qr_binding.dart';
import '../features/qr/presentation/pages/qr_page.dart';
import '../features/orders/presentation/bindings/orders_binding.dart';
import '../features/search/presentation/pages/google_search_screen.dart';
import '../features/subscription/presentation/bindings/subscription_binding.dart';
import '../features/subscription/presentation/pages/my_subscription_screen.dart';
import '../features/package/presentation/pages/available_package.dart';
import '../features/earning/presentation/bindings/earning_binding.dart';
import '../features/wallet/presentation/bindings/wallet_binding.dart';
import '../features/wallet/presentation/pages/wallet_page.dart';
import '../features/search/presentation/bindings/search_binding.dart';
import '../features/dashboard/presentation/bindings/dashboard_binding.dart';
import '../features/package/presentation/bindings/package_binding.dart';
import '../features/settings/presentation/bindings/settings_binding.dart';
import '../features/settings/presentation/pages/settings_page.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onBoarding = '/on-boarding';

  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';

  static const home = '/home';

  static const profile = '/profile';

  static const address = '/address';
  static const addAddress = '/add-address';

  static const notification = '/notification';

  static const qr = '/qr';

  static const ordersHistory = '/orders-history';
  static const dashboard = '/dashboard';
  static const selectRole = '/select-role';

  static const subscription = '/subscription';
  static const getPackage = '/get-package';

  static const earning = '/earning';

  static const wallet = '/wallet';
  static const orderDetails = '/order-details';

  static const search = '/search';
  static const sideMenu = '/menu';
  static const availableOrders = '/available-orders';

  static const settings = '/settings';
  static const privacyPolicy = '/privacy-policy';
  static const termsAndConditions = '/terms-and-conditions';

  static final pages = <GetPage>[
    // ROUTES_START
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onBoarding, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(name: otp, page: () => OTPScreen()),

    GetPage(
      name: home,
      page: () => const HomeMapScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: sideMenu,
      page: () => const MenuScreen(),
      binding: CommonBinding(),
    ),

    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(name: qr, page: () => const MyQRScreen(), binding: QrBinding()),

    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: address,
      page: () => const SavedAddressScreen(),
      binding: AddressBinding(),
    ),

    GetPage(
      name: notification,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),

    GetPage(
      name: ordersHistory,
      page: () => const OrderHistoryScreen(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: availableOrders,
      page: () => AvailableOrdersScreen(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardScreen(),
      bindings: [
        DashboardBinding(),
        HomeBinding(),
        QrBinding(),
        AddressBinding(),
        ProfileBinding(),
        CommonBinding(),
        NotificationBinding(),
        AuthBinding(),
      ],
    ),

    GetPage(
      name: selectRole,
      page: () => const SelectRoleView(),
      binding: SelectRoleBinding(),
    ),
    GetPage(
      name: subscription,
      page: () => const MySubscriptionScreen(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: getPackage,
      page: () => const AvailablePackageScreen(),
      binding: PackageBinding(),
    ),

    GetPage(
      name: earning,
      page: () => const EarningDashboardView(),
      binding: EarningBinding(),
    ),

    GetPage(
      name: wallet,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),

    GetPage(
      name: orderDetails,
      page: () {
        final orders = Get.arguments;
        return OrderDetailView(order: orders);
      },
      binding: OrdersBinding(),
    ),

    GetPage(
      name: search,
      page: () => const GoogleSearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: addAddress,
      page: () => AddPlaceScreen(),
      binding: AddressBinding(),
    ),

    GetPage(
      name: settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(
      name: termsAndConditions,
      page: () => const TermsAndConditionsScreen(),
    ),

    // ROUTES_END
  ];
}

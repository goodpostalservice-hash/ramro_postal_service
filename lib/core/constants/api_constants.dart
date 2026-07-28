import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstant {
  static String baseUrl = dotenv.get('BASE_URL');

  // user
  static String login = '$baseUrl/login';
  static String verify = '$baseUrl/check-otp';
  static String resendOtp = '$baseUrl/resend-otp';
  static String register = '$baseUrl/register';
  static String placeOrder = '$baseUrl/place-order';
  static String orderHistory = '$baseUrl/order-history';
  static String updateProfile = '$baseUrl/update-profile';
  static String logout = '$baseUrl/logout';

  // driver
  static String driverLogin = '$baseUrl/driver/login';
  static String driverVerify = '$baseUrl/driver/check-otp';
  static String driverResendOtp = '$baseUrl/driver/resend-otp';
  static String availableOrder = '$baseUrl/driver/available-orders';
  static String driverOrderHistory = '$baseUrl/driver/order-history';
  static String orderEstimate = '$baseUrl/order-estimate';
  static String acceptOrder = '$baseUrl/driver/accept-order';
  static String updateOrderStatus = '$baseUrl/driver/update-order-status';
  static String todayEarning = '$baseUrl/driver/today-earnings';
  static String earning = '$baseUrl/driver/earnings';
  static String orderDetail(int id) => '$baseUrl/driver/order-details/$id';
  static String driverLogout = '$baseUrl/driver/logout';

  // common
  static String profile = '$baseUrl/profile';
  static String myQR = '$baseUrl/my-qrcodes';
  static String availablePackages = '$baseUrl/package';
  static String locationName = '$baseUrl/get-locations';
  static String generateQR = '$baseUrl/generate-qrcode';
  static String deleteQR = '$baseUrl/delete-qrcode';
  static String getSavedAddress = '$baseUrl/my-saved-addresses';
  static String deleteSavedAddress(int id) => '$baseUrl/delete-address/$id;';
  static String saveAddress = '$baseUrl/save-address';
  static String notification = '$baseUrl/notification';
  static String addMissingPlace = '$baseUrl/add-missing-place';
  static String privacyPolicy = '$baseUrl/privacy-policy';
  static String termsAndConditions = '$baseUrl/terms-and-conditions';
  static String houseNumber = '$baseUrl/map';
  //search result
  static String searchResult = '$baseUrl/search';
  static String searchResultGoogle =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  static String wallet = '$baseUrl/wallet';
  static String subscription = '$baseUrl/my-subscription';
  static String renewSubscription = '$baseUrl/renew-subscription';
}

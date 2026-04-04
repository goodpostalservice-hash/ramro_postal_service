class ApiConstant {
  static const String baseUrl = 'https://ramropostalservice.com/api';
  static const String imageURL = 'https://ramropostalservice.com/';

  static const String verify = '$baseUrl/check-otp';
  static const String resendOtp = '$baseUrl/resend-otp';
  static const String driverVerify = '$baseUrl/driver/check-otp';
  static const String driverResendOtp = '$baseUrl/driver/resend-otp';
  static const String user = '$baseUrl/v2/register';
  static const String profile = '$baseUrl/profile';
  static const String login = '$baseUrl/login';
  static const String driverLogin = '$baseUrl/driver/login';
  static const String placeOrder = '$baseUrl/place-order';
  static const String orderHistory = '$baseUrl/order-history';
  static const String orderEstimate = '$baseUrl/order-estimate';
  static const String myQR = '$baseUrl/my-qrcodes';
  static const String availablePackages = '$baseUrl/package';

  static const String generateQR = '$baseUrl/generate-qrcode';
  static const String myPrintedQR = '$baseUrl/qr-history';
  static const String addLocation = '$baseUrl/user/location/add';
  static const String deleteQR = '$baseUrl/user/deleteqr';
  static const String setDefault = '$baseUrl/user/set-default';
  static const String slider = '$baseUrl/slider';
  static const String campaign = '$baseUrl/campaign';
  static const String notification = '$baseUrl/notification';
  static const String deleteNotification = '$baseUrl/mark_as_read';

  /// change password
  static const String updatePassword = '$baseUrl/user/change-password';

  /// update user profile
  static const String updateProfile = '$baseUrl/user/update-profile';
  static const deleteProfile = '$baseUrl/user/delete-account';

  /// forget password apis
  static const String forgetPassword = '$baseUrl/forget-password';
  static const String verifyForgetOTP = '$baseUrl/forget-password/phone/verify';
  static const String changeForgetPassword = '$baseUrl/forget-password/update';

  /// add missing place
  static const String addMissingPlace = '$baseUrl/add-missing-map';

  static const String logout = '$baseUrl/logout';
  static const String address = '$baseUrl/map-all';

  //help
  static const String faqQues = '$baseUrl/user-help';
  static const String aboutUs = '$baseUrl/about-us';
  static const String privacyPolicy = '$baseUrl/pravicy-polecy';

  // house number list
  static const String houseNumber = '$baseUrl/latest-location';

  //search result
  static const String searchResult = '$baseUrl/search-map';
  static const String searchResultGoogle =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String loginWithGoogle = '$baseUrl/google-callback';

  //chat
  static const String getChat = '$baseUrl/chat';
  static const String postChat = '$baseUrl/chat';
}

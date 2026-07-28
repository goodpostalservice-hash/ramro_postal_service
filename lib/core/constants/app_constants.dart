import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstant {
  static const String serverFailureMessage = 'Server Failure';
  static const String cacheFailureMessage = 'Cache Failure';

  /// google map
  static String googleMapAPI = dotenv.get('GOOGLE_MAP_API_KEY');

  /// map key for direction
  static String MAP_KEY = dotenv.get('MAPBOX_KEY');

  /// one signal id
  static String oneSignalAppId = "d2614737-1463-4227-b94b-0871639aa557";
}

class Assets {
  static String assetBase = 'assets';
  static String notification = "$assetBase/icons/svg/notification.svg";
  static String location = "$assetBase/icons/svg/location.svg";
  static String language = "$assetBase/icons/svg/language.svg";
  static String support = "$assetBase/icons/svg/support.svg";
  static String terms = "$assetBase/icons/svg/terms.svg";
  static String wallet = "$assetBase/icons/svg/wallet.svg";
  static String subscription = "$assetBase/icons/svg/subscription.svg";
  static String orderHistory = "$assetBase/icons/svg/order_history.svg";
  static String logout = "$assetBase/icons/svg/logout.svg";
  static String addMissingPlace = "$assetBase/icons/svg/add_missing_place.svg";
  static String mapStandard = "$assetBase/icons/standard_map.png";
  static String mapSatellite = "$assetBase/icons/satellite_map.png";
  static String mapHybrid = "$assetBase/icons/hybrid_map.png";
  static String navigation = "$assetBase/icons/svg/navigation.svg";
  static String plus = "$assetBase/icons/svg/plus.svg";
  static String share = "$assetBase/icons/svg/share.svg";
}

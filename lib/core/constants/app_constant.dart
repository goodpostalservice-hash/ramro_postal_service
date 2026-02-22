class AppConstant {
  static const String serverFailureMessage = 'Server Failure';
  static const String cacheFailureMessage = 'Cache Failure';

  static List logInfo = [];

  // save user type txt
  static String loggedInUserType = "";

  static String bearerToken = '';

  /// google map
  static String googleMapAPI = 'AIzaSyAnn9GbnUhZnAss83HeW4oeVWvyPGS2oQ4';

  /// map key for direction
  static String MAP_KEY = "AIzaSyAnn9GbnUhZnAss83HeW4oeVWvyPGS2oQ4";

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
  static String logout = "$assetBase/icons/svg/logout.svg";
  static String addMissingPlace = "$assetBase/icons/svg/add_missing_place.svg";
  static String mapStandard = "$assetBase/icons/svg/standard.svg";
  static String mapSatellite = "$assetBase/icons/svg/satellite.svg";
  static String mapHybrid = "$assetBase/icons/svg/hybrid.svg";
  static String navigation = "$assetBase/icons/svg/navigation.svg";
  static String plus = "$assetBase/icons/svg/plus.svg";
  static String share = "$assetBase/icons/svg/share.svg";
}

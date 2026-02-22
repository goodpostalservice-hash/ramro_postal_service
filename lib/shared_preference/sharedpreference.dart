import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }


  Future<String?> fetchPhoneFromSharedPreferences() async {
  String? jsonData = _sharedPreferences!.getString('user_data');

  // Print the jsonData to check its contents and validate it is valid JSON
  print(jsonData);

  if (jsonData != null) {
    try {
      Map<String, dynamic> json = jsonDecode(jsonData);
      return json['data']['phone'];
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  return null;
}
}

// Retrieve the JSON data from SharedPreferences and fetch the phone


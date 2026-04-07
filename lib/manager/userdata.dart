import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiverService {
  // get user login data
  static Future<Map<String, dynamic>?> getUserLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? getMap = await json.decode(
      prefs.getString('key').toString(),
    );
    return getMap;
  }
}

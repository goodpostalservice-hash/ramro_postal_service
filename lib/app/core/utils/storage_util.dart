import 'package:hive_flutter/adapters.dart';

import '../resource/app_strings.dart';
import '../values/const_keys.dart';

class SStorageUtil {
  static Future<void> initStorage() async {
    await Hive.initFlutter();
    await Hive.openBox(SAppStrings.application);
  }

  static Future<void> saveData({required String key, dynamic value}) async {
    await Hive.box(SAppStrings.application).put(key, value);
  }

  static T? getData<T>({required String key}) {
    return Hive.box(SAppStrings.application).get(key);
  }

  static Future<void> deleteData({required String key}) async {
    await Hive.box(SAppStrings.application).delete(key);
  }

  static Future<void> deleteAll() async {
    await Hive.box(SAppStrings.application).clear();
  }

  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveData(key: SConstKeys.accessToken, value: accessToken);
    await saveData(key: SConstKeys.refreshToken, value: refreshToken);
    await saveData(key: SConstKeys.isLoggedIn, value: true);
  }

  static Future<void> deleteAuthData() async {
    await deleteData(key: SConstKeys.accessToken);
    await deleteData(key: SConstKeys.refreshToken);
    await deleteData(key: SConstKeys.isLoggedIn);
  }
}

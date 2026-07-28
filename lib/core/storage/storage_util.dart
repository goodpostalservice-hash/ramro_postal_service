import 'package:hive_flutter/adapters.dart';

import '../constants/app_strings.dart';
import '../constants/const_keys.dart';
import '../models/user_model.dart';

class SStorageUtil {
  static Future<void> initStorage() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserDataAdapter());
    }
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

  static Future<void> saveUserData({required UserData userData}) async {
    await saveData(key: SConstKeys.userData, value: userData);
  }

  static UserData? getUserData() {
    final data = getData<dynamic>(key: SConstKeys.userData);

    if (data == null) return null;
    if (data is UserData) {
      return data;
    }
    if (data is Map) {
      return UserData.fromJson(Map<String, dynamic>.from(data));
    }

    return null;
  }

  static Future<void> deleteUserData() async {
    await deleteData(key: SConstKeys.userData);
  }

  // ─── House Marker Cache Methods ───────────────────────────────────────────
  static const String _houseCachePrefix = 'house_cache_';
  static const Duration _cacheExpiry = Duration(hours: 2);

  /// Save house data to cache
  static Future<void> saveHouseCache({
    required String cacheKey,
    required List<Map<String, dynamic>> houses,
  }) async {
    final key = '$_houseCachePrefix$cacheKey';
    final now = DateTime.now().millisecondsSinceEpoch;

    final data = houses.map((h) {
      h['at'] = now;
      return h;
    }).toList();

    await saveData(key: key, value: data);
  }

  /// Get house data from cache
  static List<Map<String, dynamic>>? getHouseCache({required String cacheKey}) {
    final key = '$_houseCachePrefix$cacheKey';
    final data = getData<List>(key: key);

    if (data == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    final expiryMs = _cacheExpiry.inMilliseconds;
    final validHouses = <Map<String, dynamic>>[];

    for (final item in data) {
      if (item is Map) {
        final map = Map<String, dynamic>.from(item);
        final cachedAt = map['at'] as int? ?? 0;

        if (now - cachedAt <= expiryMs) {
          validHouses.add(map);
        }
      }
    }

    return validHouses.isEmpty ? null : validHouses;
  }

  /// Clear all house marker cache entries
  static Future<void> clearHouseCache() async {
    final box = Hive.box(SAppStrings.application);
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      if (key.toString().startsWith(_houseCachePrefix)) {
        keysToDelete.add(key.toString());
      }
    }

    if (keysToDelete.isNotEmpty) {
      await box.deleteAll(keysToDelete);
    }
  }

  /// Clean expired cache entries (call periodically)
  static Future<void> cleanExpiredHouseCache() async {
    final box = Hive.box(SAppStrings.application);
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiryMs = _cacheExpiry.inMilliseconds;
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      final keyStr = key.toString();
      if (!keyStr.startsWith(_houseCachePrefix)) continue;

      final data = box.get(key);
      if (data is! List) continue;

      bool allExpired = true;
      for (final item in data) {
        if (item is Map) {
          final cachedAt = item['at'] as int? ?? 0;
          if (now - cachedAt <= expiryMs) {
            allExpired = false;
            break;
          }
        }
      }

      if (allExpired) {
        keysToDelete.add(keyStr);
      }
    }

    if (keysToDelete.isNotEmpty) {
      await box.deleteAll(keysToDelete);
    }
  }
}

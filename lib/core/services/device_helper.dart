import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class DeviceHelper {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final NetworkInfo _networkInfo = NetworkInfo();

  static Future<String?> getIpAddress() async {
    return _networkInfo.getWifiIP();
  }

  static Future<String> _getFallbackDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    final savedId = prefs.getString('fallback_device_id');
    if (savedId != null && savedId.isNotEmpty) {
      return savedId;
    }

    final newId = const Uuid().v4();
    await prefs.setString('fallback_device_id', newId);
    return newId;
  }

  static Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidId = await const AndroidId().getId();

        if (androidId != null && androidId.isNotEmpty) {
          return androidId;
        }
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final vendorId = iosInfo.identifierForVendor;

        if (vendorId != null && vendorId.isNotEmpty) {
          return vendorId;
        }
      }
    } catch (_) {
      // fallback below
    }

    return _getFallbackDeviceId();
  }

  static Future<Map<String, dynamic>> getDeviceData() async {
    final ipAddress = await getIpAddress();
    final deviceId = await getDeviceId();

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
 
      return {
        'device_id': deviceId,
        'device_type': 'android',
        'device_model': androidInfo.model,
        'device_brand': androidInfo.brand,
        'device_name': androidInfo.device,
        'os_version': androidInfo.version.release,
        'ip_address': ipAddress,
      };
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;

      return {
        'device_id': deviceId,
        'device_type': 'ios',
        'device_model': iosInfo.model,
        'device_name': iosInfo.name,
        'os_version': iosInfo.systemVersion,
        'ip_address': ipAddress,
      };
    }

    return {
      'device_id': deviceId,
      'device_type': 'unknown',
      'ip_address': ipAddress,
    };
  }
}

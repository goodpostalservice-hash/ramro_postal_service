import 'package:network_info_plus/network_info_plus.dart';

class NetworkHelper {
  static final NetworkInfo _networkInfo = NetworkInfo();

  static Future<String?> getWifiIpAddress() async {
    return await _networkInfo.getWifiIP();
  }

  static Future<String?> getWifiName() async {
    return await _networkInfo.getWifiName();
  }

  static Future<String?> getWifiGatewayIp() async {
    return await _networkInfo.getWifiGatewayIP();
  }
}

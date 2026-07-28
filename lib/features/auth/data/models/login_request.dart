class LoginRequest {
  final String phone;
  final String countryCode;
  final String currentLatitude;
  final String currentLongitude;
  final String ipAddress;
  final String macAddress;

  LoginRequest({
    required this.phone,
    required this.countryCode,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.ipAddress,
    required this.macAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'country_code': countryCode,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'ip_address': ipAddress,
      'mac_address': macAddress,
    };
  }
}

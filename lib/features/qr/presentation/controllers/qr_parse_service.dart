import 'dart:convert';

import 'package:flutter/foundation.dart';

class QrParseService {
  const QrParseService();

  QrLocationData? parseLocation(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) return null;

      final lat = double.tryParse(
        decoded['destination_latitude']?.toString() ?? '',
      );
      final lng = double.tryParse(
        decoded['destination_longitude']?.toString() ?? '',
      );

      if (lat == null || lng == null) return null;

      

      return QrLocationData(
        latitude: lat,
        longitude: lng,
        isStaticRoute: decoded['is_static_route']?.toString() ?? '0',
        userType: decoded['user_type']?.toString() ?? '',
        auth: decoded['auth']?.toString() ?? '0',
      );
    } catch (error) {
      debugPrint('Invalid QR JSON: $error');
      return null;
    }
  }
}

class QrLocationData {
  const QrLocationData({
    required this.latitude,
    required this.longitude,
    required this.isStaticRoute,
    required this.userType,
    required this.auth,
  });

  final double latitude;
  final double longitude;
  final String isStaticRoute;
  final String userType;
  final String auth;
}

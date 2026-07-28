import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/services/location_service.dart';
import 'package:ramro_postal_service/core/services/location_service_permission.dart';

import '../../../home/presentation/pages/home_map_screen.dart';

class SplashController {
  LatLng? pos;

  Future<bool> determinePosition() async {
    try {
      // 1. Use the permission service
      final permService = Get.find<LocationPermissionService>();
      final hasPermission = await permService.requestPermission(Get.context!);
      if (!hasPermission) return false; // dialog already shown

      // 2. Check GPS service is on (optional but good practice)
      if (!permService.isServiceEnabled) {
        debugPrint('Location services are disabled.');
        return false;
      }

      // 3. Get current location using the location service
      final position = await LocationService.getCurrentLocation();

      pos = position;
      return true;
    } catch (e) {
      debugPrint('Location error: $e');
      return false;
    } finally {
      // Your existing fallback / saving logic
      HomeMapScreen.currentLocationAtStart = LatLng(
        pos?.latitude ?? 27.67584,
        pos?.longitude ?? 85.351375,
      );
    }
  }
}

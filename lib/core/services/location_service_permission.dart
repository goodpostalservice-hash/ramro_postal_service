// location_permission_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionState { unknown, granted, denied, deniedForever }

class LocationPermissionService extends GetxService {
  final _state = LocationPermissionState.unknown.obs;
  final _serviceEnabled = false.obs;

  LocationPermissionState get state => _state.value;
  bool get isGranted => _state.value == LocationPermissionState.granted;
    Rx<LocationPermissionState> get stateRx => _state;

  bool get isServiceEnabled => _serviceEnabled.value;

  StreamSubscription<ServiceStatus>? _serviceSub;

  @override
  void onInit() {
    super.onInit();
    _monitorStatus();
    ever(_state, _onStateChanged);
  }

  @override
  void onClose() {
    _serviceSub?.cancel();
    super.onClose();
  }

  /// Check current status and update observables.
  Future<void> checkStatus() async {
    try {
      _serviceEnabled.value = await Geolocator.isLocationServiceEnabled();
      final perm = await Geolocator.checkPermission();
      _updatePermission(perm);
    } catch (_) {
      _state.value = LocationPermissionState.denied;
    }
  }

  /// Request permission and return true if granted.
  Future<bool> requestPermission(BuildContext? context) async {
    // Check service first
    final serviceOk = await Geolocator.isLocationServiceEnabled();
    _serviceEnabled.value = serviceOk;
    if (!serviceOk) {
      if (context != null) _showServiceDisabledDialog(context);
      return false;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    _updatePermission(perm);

    if (perm == LocationPermission.denied) {
      if (context != null) _showPermissionDeniedDialog(context);
      return false;
    }
    if (perm == LocationPermission.deniedForever) {
      if (context != null) _showSettingsDialog(context);
      return false;
    }
    return true;
  }

  /// Open app settings reliably.
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  void _updatePermission(LocationPermission perm) {
    switch (perm) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        _state.value = LocationPermissionState.granted;
        break;
      case LocationPermission.denied:
        _state.value = LocationPermissionState.denied;
        break;
      case LocationPermission.deniedForever:
        _state.value = LocationPermissionState.deniedForever;
        break;
      case LocationPermission.unableToDetermine:
        throw UnimplementedError();
    }
  }

void _monitorStatus() {
  _serviceSub = Geolocator.getServiceStatusStream().listen((status) {
    _serviceEnabled.value = status == ServiceStatus.enabled;
    if (!_serviceEnabled.value) {
      _state.value = LocationPermissionState.denied;
    }
  });

  // Instead of a non-existent stream, use a periodic timer
  Timer.periodic(const Duration(seconds: 3), (_) async {
    if (!_serviceEnabled.value) return; // No need to check if service is off
    final perm = await Geolocator.checkPermission();
    _updatePermission(perm);
  });
}

  void _onStateChanged(LocationPermissionState state) {
    // Optional: show a global snackbar or dialog when permission is lost while navigating
    debugPrint('LocationPermissionState changed to: $state');
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Location permission required'),
        content: const Text('Navigation needs location access.'),
        actions: [
          TextButton(
            onPressed: () => requestPermission(context),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  void _showServiceDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Location is disabled'),
        content: const Text('Please enable location services.'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permission permanently denied'),
        content: const Text('Grant location permission in Settings.'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

    static Stream<Position> locationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
      ),
    );
  }
}
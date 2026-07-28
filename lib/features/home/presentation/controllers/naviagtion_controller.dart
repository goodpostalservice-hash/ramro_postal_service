import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation_plus/flutter_mapbox_navigation_plus.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';

class MapboxNavigationController extends GetxController {
  final RxBool isInitialized = false.obs;
  final RxBool routeBuilt = false.obs;
  final RxBool isNavigating = false.obs;
  final RxBool isMultipleStop = false.obs;

  final RxString platformVersion = ''.obs;
  final RxString instruction = ''.obs;

  final RxDouble distanceRemaining = 0.0.obs;
  final RxDouble durationRemaining = 0.0.obs;

  late MapBoxOptions navigationOption;

  @override
  void onInit() {
    super.onInit();
    initializeNavigation();
  }

  Future<void> initializeNavigation() async {
    navigationOption = MapBoxNavigation.instance.getDefaultOptions();

    navigationOption.simulateRoute = true; // false for real navigation
    navigationOption.language = "en";
    navigationOption.units = VoiceUnits.metric;
    navigationOption.voiceInstructionsEnabled = true;
    navigationOption.bannerInstructionsEnabled = true;
    navigationOption.mode = MapBoxNavigationMode.driving;
    navigationOption.allowsUTurnAtWayPoints = true;

    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);

    try {
      final version = await MapBoxNavigation.instance.getPlatformVersion();
      platformVersion.value = version ?? '';
    } on PlatformException {
      platformVersion.value = 'Failed to get platform version';
    }

    isInitialized.value = true;
  }

  Future<void> startNavigation({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    String originName = 'Origin',
    String destinationName = 'Destination',
    bool simulateRoute = true,
  }) async {
    if (!isInitialized.value) {
      await initializeNavigation();
    }

    final List<WayPoint> wayPoints = [
      WayPoint(
        name: originName,
        latitude: originLat,
        longitude: originLng,
        isSilent: true,
      ),
      WayPoint(
        name: destinationName,
        latitude: destinationLat,
        longitude: destinationLng,
        isSilent: false,
      ),
    ];

    final options = MapBoxOptions.from(navigationOption);
    options.simulateRoute = simulateRoute;
    options.language = "en";
    options.units = VoiceUnits.metric;
    options.voiceInstructionsEnabled = true;
    options.bannerInstructionsEnabled = true;
    options.mode = MapBoxNavigationMode.driving;
    options.allowsUTurnAtWayPoints = true;

    isMultipleStop.value = wayPoints.length > 2;

    await MapBoxNavigation.instance.startNavigation(
      wayPoints: wayPoints,
      options: options,
    );
  }

  Future<void> startTestNavigation() async {
    await startNavigation(
      originName: "City Hall",
      originLat: 42.886448,
      originLng: -78.878372,
      destinationName: "Downtown Buffalo",
      destinationLat: 42.8866177,
      destinationLng: -78.8814924,
      simulateRoute: true,
    );
  }

  Future<void> startFreeDrive() async {
    await MapBoxNavigation.instance.startFreeDrive();
  }

  Future<void> finishNavigation() async {
    await MapBoxNavigation.instance.finishNavigation();
    isNavigating.value = false;
    routeBuilt.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining.value =
        (await MapBoxNavigation.instance.getDistanceRemaining()) ?? 0;

    durationRemaining.value =
        (await MapBoxNavigation.instance.getDurationRemaining()) ?? 0;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        final progressEvent = e.data as RouteProgressEvent;
        final currentInstruction = progressEvent.currentStepInstruction;

        if (currentInstruction != null && currentInstruction.isNotEmpty) {
          instruction.value = currentInstruction;
        }
        break;

      case MapBoxEvent.route_building:
        routeBuilt.value = false;
        break;

      case MapBoxEvent.route_built:
        routeBuilt.value = true;
        break;

      case MapBoxEvent.route_build_failed:
        routeBuilt.value = false;
        Get.snackbar('Route failed', 'Could not build navigation route.');
        break;

      case MapBoxEvent.navigation_running:
        isNavigating.value = true;
        break;

      case MapBoxEvent.on_arrival:
        if (!isMultipleStop.value) {
          await Future.delayed(const Duration(seconds: 3));
          await finishNavigation();
        }
        break;

      case MapBoxEvent.navigation_finished:
        await finishNavigation();
      case MapBoxEvent.navigation_cancelled:
        routeBuilt.value = false;
        isNavigating.value = false;
        await finishNavigation();
        break;

      default:
        break;
    }
  }
}

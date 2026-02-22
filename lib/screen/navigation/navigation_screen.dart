import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_export.dart';
import 'bottom_bar.dart';
import 'instruction_panel.dart';
import 'naviagtion_controller.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, LatLng>;
    final controller = Get.put(NaviagtionController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startNavigation(
        origin: args['origin']!,
        destination: args['destination']!,
      );
    });
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: appTheme.white,
          systemNavigationBarColor: appTheme.white,
        ),
        child: Stack(
          children: [
            GetBuilder<NaviagtionController>(
              builder: (value) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: args['origin']!,
                    zoom: 14,
                  ),
                  onMapCreated: value.onMapCreated,
                  zoomControlsEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(15, 18),
                  myLocationEnabled: true,
                  polylines: value.polylines,
                  markers: value.markers,
                );
              },
            ),
            Obx(() {
              final dir = controller.currentDirections.value;
              if (dir == null) return const SizedBox.shrink();
              return TurnInstructionBanner(
                instruction: dir.nextStepInstruction,
                distance: dir.nextStepDistance,
                maneuver: dir.nextManeuverType,
              );
            }),
            Obx(() {
              final dir = controller.currentDirections.value;
              if (dir == null) return const SizedBox.shrink();
              return NavigationBottomBar(
                duration: dir.totalDuration,
                distance: dir.totalDistance,
                arrivalTime: controller.estimatedArrivalTime,
                onRecenter: controller.recenterMap,
                onExit: () => Get.back(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

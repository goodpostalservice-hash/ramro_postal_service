import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ramro_postal_service/core/constants/app_export.dart';

import 'naviagtion_controller.dart';
import 'polyline_decoder.dart';

class NavigationService {
  static Future<DirectionsModel?> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${AppConstant.MAP_KEY}',
    );
    final res = await http.get(url);
    final data = json.decode(res.body);
    if (data['status'] != 'OK') return null;

    final route = data['routes'][0];
    final polyline = route['overview_polyline']['points'];
    final points = PolylineDecoder.decodePolyline(polyline);

    final steps = route['legs'][0]['steps'] as List;
    final instructions = steps
        .map(
          (e) => e['html_instructions'].toString().replaceAll(
            RegExp('<[^>]*>'),
            '',
          ),
        )
        .toList();
    final nextStep = steps.first;
    final maneuver = nextStep['maneuver'] ?? 'straight';

    print("steps:$steps");
    print("instructions:$instructions");
    print("next step:$nextStep");
    print("maneuver:$maneuver");
    return DirectionsModel(
      polylinePoints: points,
      bounds: LatLngBounds(
        southwest: LatLng(
          route['bounds']['southwest']['lat'],
          route['bounds']['southwest']['lng'],
        ),
        northeast: LatLng(
          route['bounds']['northeast']['lat'],
          route['bounds']['northeast']['lng'],
        ),
      ),
      instructions: instructions,
      totalDistance: route['legs'][0]['distance']['text'],
      totalDuration: route['legs'][0]['duration']['text'],
      nextStepDistance: nextStep['distance']['text'],
      nextStepInstruction: nextStep['html_instructions'].toString().replaceAll(
        RegExp('<[^>]*>'),
        '',
      ),
      nextManeuverType: maneuver,
    );
  }

  static bool isOnRoute(LatLng current, List<LatLng> route) {
    for (final point in route) {
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        point.latitude,
        point.longitude,
      );
      if (distance < 30) return true;
    }
    return false;
  }
}

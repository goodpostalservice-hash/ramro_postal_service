import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../home_map/home_map_screen/presentation/driver_home_map_screen.dart';

class SplashController {
  late Position pos;

  Future<bool> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }
      Position position = await Geolocator.getCurrentPosition();
      DriverHomeMapScreen.currentLocationAtStart = LatLng(
        position.latitude,
        position.longitude,
      );
      pos = position;
      return true;
    } catch (e) {
      return false;
    }
  }
}

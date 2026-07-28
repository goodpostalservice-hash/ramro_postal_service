import 'package:google_maps_flutter/google_maps_flutter.dart';

class HouseLabelOverlay {
  final String id;
  final String label;
  final LatLng position;
  final double x;
  final double y;
  final String? fullAddress;
  final bool isHighlighted;

  HouseLabelOverlay({
    required this.id,
    required this.label,
    required this.position,
    required this.x,
    required this.y,
    this.fullAddress,
    this.isHighlighted = false,
  });
}

class MapDataRequest {
  double? zoomLevel;
  double? latitude;
  double? longitude;
  String? radius;
  String? north;
  String? east;
  String? west;
  String? south;

  MapDataRequest({
    this.zoomLevel,
    this.latitude,
    this.longitude,
    this.radius,
    this.north,
    this.east,
    this.west,
    this.south,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zoom_level'] = zoomLevel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    data['north'] = north;
    data['east'] = east;
    data['west'] = west;
    data['south'] = south;
    return data;
  }
}

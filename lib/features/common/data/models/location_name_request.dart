class LocationNameRequest {
  final String latitude;
  final String longitude;

  const LocationNameRequest({
    required this.latitude,
    required this.longitude,
  });

  factory LocationNameRequest.fromJson(Map<String, dynamic> json) {
    return LocationNameRequest(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class SaveAddressRequest {
  final String coordinates;
  final String address;
  final String? label;

  const SaveAddressRequest({
    required this.coordinates,
    required this.address,
    required this.label,
  });

  factory SaveAddressRequest.fromJson(Map<String, dynamic> json) {
    return SaveAddressRequest(
      coordinates: json['coordinates'] as String,
      address: json['address'] as String,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates,
      'address': address,
      'label': label,
    };
  }
}

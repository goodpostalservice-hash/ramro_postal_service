class GenerateQrRequest {
  String? destinationLatitude;
  String? destinationLognitude;
  int? isStaticRoute;
  String? userType;
  String? auth;
  String? label;
  String? fullAddress;

  GenerateQrRequest({
    this.destinationLatitude,
    this.destinationLognitude,
    this.isStaticRoute,
    this.userType,
    this.auth,
    this.label,
    this.fullAddress,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination_latitude'] = destinationLatitude;
    data['destination_longitude'] = destinationLognitude;
    data['is_static_route'] = isStaticRoute;
    data['user_type'] = userType;
    data['auth'] = auth;
    data['label'] = label;
    data['full_address'] = fullAddress;
    return data;
  }
}

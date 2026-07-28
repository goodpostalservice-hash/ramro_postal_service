class LocationDataResponse {
  final bool? success;
  final String? message;
  final LocationData? data;

  LocationDataResponse({this.success, this.message, this.data});

  factory LocationDataResponse.fromJson(Map<String, dynamic> json) {
    return LocationDataResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? LocationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LocationData {
  int? id;
  String? longitude;
  String? latitude;
  String? cordinate;
  String? zipCode;
  String? area;
  String? zone;
  String? subZone;
  String? street;
  String? houseNum;
  String? fullAddressDetail;
  String? locationName;
  // double? distance;

  LocationData({
    this.id,
    this.longitude,
    this.latitude,
    this.cordinate,
    this.zipCode,
    this.area,
    this.zone,
    this.subZone,
    this.street,
    this.houseNum,
    this.fullAddressDetail,
    this.locationName,
    // this.distance,
  });

  LocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    cordinate = json['cordinate'];
    zipCode = json['zip_code'];
    area = json['area'];
    zone = json['zone'];
    subZone = json['sub_zone'];
    street = json['street'];
    houseNum = json['house_num'];
    fullAddressDetail = json['full_address_detail'];
    locationName = json['location_name'];
    // distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['cordinate'] = cordinate;
    data['zip_code'] = zipCode;
    data['area'] = area;
    data['zone'] = zone;
    data['sub_zone'] = subZone;
    data['street'] = street;
    data['house_num'] = houseNum;
    data['full_address_detail'] = fullAddressDetail;
    data['location_name'] = locationName;
    // data['distance'] = distance;
    return data;
  }
}

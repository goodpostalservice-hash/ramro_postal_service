class AddLocationRequest {
  String? latitude;
  String? longitude;
  String? cordinate;
  String? zipCode;
  String? area;
  String? zone;
  String? subZone;
  String? street;
  String? houseNumber;
  String? fullAddressDetail;
  String? locationName;

  AddLocationRequest({
    this.latitude,
    this.longitude,
    this.cordinate,
    this.zipCode,
    this.area,
    this.zone,
    this.subZone,
    this.street,
    this.houseNumber,
    this.fullAddressDetail,
    this.locationName,
  });

  AddLocationRequest.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    cordinate = json['cordinate'];
    zipCode = json['zip_code'];
    area = json['area'];
    zone = json['zone'];
    subZone = json['sub_zone'];
    street = json['street'];
    houseNumber = json['house_number'];
    fullAddressDetail = json['full_address_detail'];
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['cordinate'] = cordinate;
    data['zip_code'] = zipCode;
    data['area'] = area;
    data['zone'] = zone;
    data['sub_zone'] = subZone;
    data['street'] = street;
    data['house_number'] = houseNumber;
    data['full_address_detail'] = fullAddressDetail;
    data['location_name'] = locationName;
    return data;
  }
}

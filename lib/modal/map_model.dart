class MapModel {
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
  String? createdAt;
  String? updatedAt;

  MapModel(
      {this.id,
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
      this.createdAt,
      this.updatedAt});

  MapModel.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

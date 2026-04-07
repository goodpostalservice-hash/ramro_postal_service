class AddMissingPlaceResponseModel {
  bool? success;
  AddLocationData? data;
  String? message;

  AddMissingPlaceResponseModel({this.success, this.data, this.message});

  AddMissingPlaceResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AddLocationData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class AddLocationData {
  String? longitude;
  String? latitude;
  String? locationName;
  String? fullAddressDetail;
  String? houseNum;

  AddLocationData({
    this.longitude,
    this.latitude,
    this.locationName,
    this.fullAddressDetail,
    this.houseNum,
  });

  AddLocationData.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    locationName = json['location_name'];
    fullAddressDetail = json['full_address_detail'];
    houseNum = json['house_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['location_name'] = locationName;
    data['full_address_detail'] = fullAddressDetail;
    data['house_num'] = houseNum;
    return data;
  }
}

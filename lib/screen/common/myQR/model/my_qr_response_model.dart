class MyQRResponseModel {
  int? id;
  int? userId;
  String? longitude;
  String? latitude;
  int? ishomeaddress;
  int? addOnMap;
  String? deleveryAddress;
  int? isDefault;
  String? addressType;
  String? addressMap;
  String? createdAt;
  String? updatedAt;

  MyQRResponseModel({
    this.id,
    this.userId,
    this.longitude,
    this.latitude,
    this.ishomeaddress,
    this.addOnMap,
    this.deleveryAddress,
    this.isDefault,
    this.addressType,
    this.addressMap,
    this.createdAt,
    this.updatedAt,
  });

  MyQRResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    ishomeaddress = json['ishomeaddress'];
    addOnMap = json['add_on_map'];
    deleveryAddress = json['delevery_address'];
    isDefault = json['is_default'];
    addressType = json['address_type'];
    addressMap = json['address_map'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['ishomeaddress'] = ishomeaddress;
    data['add_on_map'] = addOnMap;
    data['delevery_address'] = deleveryAddress;
    data['is_default'] = isDefault;
    data['address_type'] = addressType;
    data['address_map'] = addressMap;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

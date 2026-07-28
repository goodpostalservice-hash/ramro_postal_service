class SavedAddressResponse {
  bool? success;
  List<Addresses>? addresses;

  SavedAddressResponse({this.success, this.addresses});

  SavedAddressResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int? id;
  int? userId;
  String? coordinates;
  String? address;
  String? label;
  String? createdAt;
  String? updatedAt;

  Addresses({
    this.id,
    this.userId,
    this.coordinates,
    this.address,
    this.label,
    this.createdAt,
    this.updatedAt,
  });

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    coordinates = json['coordinates'];
    address = json['address'];
    label = json['label'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['coordinates'] = coordinates;
    data['address'] = address;
    data['label'] = label;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

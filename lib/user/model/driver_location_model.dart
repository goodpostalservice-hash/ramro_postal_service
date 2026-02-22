class DriverLocationModel {
  int? id;
  int? userId;
  String? longitude;
  String? latitude;
  int? status;
  String? createdAt;
  String? updatedAt;

  DriverLocationModel(
      {this.id,
      this.userId,
      this.longitude,
      this.latitude,
      this.status,
      this.createdAt,
      this.updatedAt});

  DriverLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

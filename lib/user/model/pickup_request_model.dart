class PickUpRequestModel {
  bool? success;
  String? message;
  Data? data;

  PickUpRequestModel({this.success, this.message, this.data});

  PickUpRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? pickupId;
  String? status;
  int? accepetUserId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.pickupId,
      this.status,
      this.accepetUserId,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    pickupId = json['pickup_id'];
    status = json['status'];
    accepetUserId = json['accepet_user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pickup_id'] = pickupId;
    data['status'] = status;
    data['accepet_user_id'] = accepetUserId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

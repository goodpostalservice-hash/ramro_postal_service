class MyQRResponse {
  int? id;
  String? uuid;
  int? userId;
  String? userType;
  String? qrcodePath;
  String? label;
  String? fullAddress;
  String? destinationLatitude;
  String? destinationLongitude;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  MyQRResponse({
    this.id,
    this.uuid,
    this.userId,
    this.userType,
    this.label,
    this.fullAddress,
    this.destinationLatitude,
    this.destinationLongitude,
    this.qrcodePath,
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });

  MyQRResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    userType = json['user_type'];
    label = json['label'];
    fullAddress = json['full_address'];
    destinationLatitude = json['destination_latitude']?.toString();
    destinationLongitude = json['destination_longitude']?.toString();
    qrcodePath = json['qrcode_path'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

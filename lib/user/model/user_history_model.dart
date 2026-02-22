class UserHistoryModel {
  int? id;
  int? userId;
  int? driverId;
  int? pickupType;
  String? scheduleTime;
  String? longitude;
  String? latitude;
  String? cordinate;
  String? pickupAddress;
  int? notes;
  int? isAccept;
  int? isArrived;
  int? isOngoing;
  int? isCancel;
  int? isCompleteVerified;
  int? isComplete;
  String? userLatitude;
  String? userLongitude;
  double? userCordinate;
  int? status;
  int? isActive;
  String? destinationAddress;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  UserHistoryModel(
      {this.id,
      this.userId,
      this.driverId,
      this.pickupType,
      this.scheduleTime,
      this.longitude,
      this.latitude,
      this.cordinate,
      this.pickupAddress,
      this.notes,
      this.isAccept,
      this.isArrived,
      this.isOngoing,
      this.isCancel,
      this.isCompleteVerified,
      this.isComplete,
      this.userLatitude,
      this.userLongitude,
      this.userCordinate,
      this.status,
      this.isActive,
      this.destinationAddress,
      this.remarks,
      this.createdAt,
      this.updatedAt});

  UserHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    driverId = json['driver_id'];
    pickupType = json['pickup_type'];
    scheduleTime = json['schedule_time'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    cordinate = json['cordinate'];
    pickupAddress = json['pickup_address'];
    notes = json['notes'];
    isAccept = json['is_accept'];
    isArrived = json['is_arrived'];
    isOngoing = json['is_ongoing'];
    isCancel = json['is_cancel'];
    isCompleteVerified = json['is_complete_verified'];
    isComplete = json['is_complete'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
    userCordinate = json['user_cordinate'];
    status = json['status'];
    isActive = json['is_active'];
    destinationAddress = json['destination_address'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['driver_id'] = driverId;
    data['pickup_type'] = pickupType;
    data['schedule_time'] = scheduleTime;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['cordinate'] = cordinate;
    data['pickup_address'] = pickupAddress;
    data['notes'] = notes;
    data['is_accept'] = isAccept;
    data['is_arrived'] = isArrived;
    data['is_ongoing'] = isOngoing;
    data['is_cancel'] = isCancel;
    data['is_complete_verified'] = isCompleteVerified;
    data['is_complete'] = isComplete;
    data['user_latitude'] = userLatitude;
    data['user_longitude'] = userLongitude;
    data['user_cordinate'] = userCordinate;
    data['status'] = status;
    data['is_active'] = isActive;
    data['destination_address'] = destinationAddress;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class LoginResponse {
  bool? success;
  String? message;
  Data? data;

  LoginResponse({this.success, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
  User? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  int? id;
  String? uuid;
  String? firstName;
  String? lastName;
  Null image;
  dynamic email;
  Null emailVerifiedAt;
  String? countryCode;
  String? phone;
  int? isPhoneVerified;
  String? currentLatitude;
  String? currentLongitude;
  String? currentCoordinates;
  String? lastCoordinates;
  String? lastLatitude;
  String? lastLongitude;
  String? ipAddress;
  String? lastLoginIp;
  String? lastLoginAt;
  String? userType;
  dynamic isOnline;
  String? status;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.uuid,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.emailVerifiedAt,
    this.countryCode,
    this.phone,
    this.isPhoneVerified,
    this.currentLatitude,
    this.currentLongitude,
    this.currentCoordinates,
    this.lastCoordinates,
    this.lastLatitude,
    this.lastLongitude,
    this.ipAddress,
    this.lastLoginIp,
    this.lastLoginAt,
    this.userType,
    this.isOnline,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    isPhoneVerified = json['isPhoneVerified'];
    currentLatitude = json['current_latitude'];
    currentLongitude = json['current_longitude'];
    currentCoordinates = json['current_coordinates'];
    lastCoordinates = json['last_coordinates'];
    lastLatitude = json['last_latitude'];
    lastLongitude = json['last_longitude'];
    ipAddress = json['ip_address'];
    lastLoginIp = json['last_login_ip'];
    lastLoginAt = json['last_login_at'];
    userType = json['user_type'];
    isOnline = json['is_online'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['isPhoneVerified'] = isPhoneVerified;
    data['current_latitude'] = currentLatitude;
    data['current_longitude'] = currentLongitude;
    data['current_coordinates'] = currentCoordinates;
    data['last_coordinates'] = lastCoordinates;
    data['last_latitude'] = lastLatitude;
    data['last_longitude'] = lastLongitude;
    data['ip_address'] = ipAddress;
    data['last_login_ip'] = lastLoginIp;
    data['last_login_at'] = lastLoginAt;
    data['user_type'] = userType;
    data['is_online'] = isOnline;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

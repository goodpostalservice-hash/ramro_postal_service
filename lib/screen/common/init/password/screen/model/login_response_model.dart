class LoginResponseModel {
  bool? success;
  String? message;
  String? token;
  String? tokenType;
  UserData? data;

  LoginResponseModel({
    this.success,
    this.message,
    this.token,
    this.tokenType,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    tokenType = json['token_type'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
    data['token_type'] = tokenType;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? image;
  String? email;
  String? phone;
  int? isPhoneVerified;
  int? userType;
  DateTime? emailVerifiedAt;
  String? address;
  String? dateOfBirth;
  String? gender;
  String? createdAt;
  String? updatedAt;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.phone,
    this.isPhoneVerified,
    this.userType,
    this.emailVerifiedAt,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    email = json['email'];
    phone = json['phone'];
    isPhoneVerified = json['isPhoneVerified'];
    userType = json['user_type'];
    emailVerifiedAt = json['email_verified_at'];
    address = json['address'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    data['email'] = email;
    data['phone'] = phone;
    data['isPhoneVerified'] = isPhoneVerified;
    data['user_type'] = userType;
    data['email_verified_at'] = emailVerifiedAt;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

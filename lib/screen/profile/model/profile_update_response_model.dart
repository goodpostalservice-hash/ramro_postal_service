class ProfileUpdateResponseModel {
  bool? success;
  String? message;
  ProfileUpdateData? data;

  ProfileUpdateResponseModel({this.success, this.message, this.data});

  ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? ProfileUpdateData.fromJson(json['data']) : null;
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

class ProfileUpdateData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  int? isPhoneVerified;
  DateTime? emailVerifiedAt;
  String? address;
  String? dateOfBirth;
  String? gender;
  String? createdAt;
  String? updatedAt;

  ProfileUpdateData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });

  ProfileUpdateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    isPhoneVerified = json['isPhoneVerified'];
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
    data['email'] = email;
    data['phone'] = phone;
    data['isPhoneVerified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UpdateProfileResponse {
  bool? success;
  String? message;
  ProfileUpdateData? data;

  UpdateProfileResponse({this.success, this.message, this.data});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ProfileUpdateData.fromJson(json['data'])
        : null;
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
}

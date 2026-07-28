class UpdateProfileRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? dateOfBirth;
  String? phone;

  UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.dateOfBirth,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['phone'] = phone;
    return data;
  }
}

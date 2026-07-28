class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phone;

  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'country_code': countryCode,
      'phone': phone,
    };
  }
}

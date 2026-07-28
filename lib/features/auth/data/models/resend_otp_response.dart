class ResendOtpResponse {
  bool? success;
  String? message;

  ResendOtpResponse({this.success, this.message});

  ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }
}

class OtpCheckRequest {
  String? otp;
  String? phone;

  OtpCheckRequest({this.otp, this.phone});

  OtpCheckRequest.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['phone'] = phone;
    return data;
  }
}

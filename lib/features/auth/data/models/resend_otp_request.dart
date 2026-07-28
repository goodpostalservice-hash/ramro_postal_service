class ResendOtpRequest {
  String? phone;

  ResendOtpRequest({this.phone});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    return data;
  }
}

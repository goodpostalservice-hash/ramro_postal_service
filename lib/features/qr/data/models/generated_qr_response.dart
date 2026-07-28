class GeneratedQRResponse {
  bool? success;
  String? qrcode;

  GeneratedQRResponse({this.success, this.qrcode});

  GeneratedQRResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    qrcode = json['qrcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['qrcode'] = qrcode;
    return data;
  }
}

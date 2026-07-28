class DeleteQrRequest {
  final int qrcode_id;

  const DeleteQrRequest({required this.qrcode_id});

  factory DeleteQrRequest.fromJson(Map<String, dynamic> json) {
    return DeleteQrRequest(qrcode_id: json['qrcode_id'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'qrcode_id': qrcode_id};
  }
}

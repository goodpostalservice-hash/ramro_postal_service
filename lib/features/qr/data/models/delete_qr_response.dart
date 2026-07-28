class DeleteQrResponse {
  final bool success;

  const DeleteQrResponse({required this.success});

  factory DeleteQrResponse.fromJson(Map<String, dynamic> json) {
    return DeleteQrResponse(success: json['success'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {'success': success};
  }
}

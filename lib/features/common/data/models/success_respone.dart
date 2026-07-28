class SuccessResponse {
  final bool success;
  final String message;

  SuccessResponse({required this.success, required this.message});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }
}

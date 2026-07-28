class UpdateOrderResponse {
  final bool success;
  final String message;

  const UpdateOrderResponse({required this.success, required this.message});

  factory UpdateOrderResponse.fromJson(Map<String, dynamic> json) {
    return UpdateOrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}

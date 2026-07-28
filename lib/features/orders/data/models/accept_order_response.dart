class AcceptOrderResponse {
  final bool success;
  final String message;

  const AcceptOrderResponse({required this.success, required this.message});

  factory AcceptOrderResponse.fromJson(Map<String, dynamic> json) {
    return AcceptOrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}

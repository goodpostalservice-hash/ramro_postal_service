class UpdateOrderRequest {
  final int order_id;
  final String status;

  const UpdateOrderRequest({
    required this.order_id,
    required this.status,
  });

  factory UpdateOrderRequest.fromJson(Map<String, dynamic> json) {
    return UpdateOrderRequest(
      order_id: json['order_id'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'status': status,
    };
  }
}

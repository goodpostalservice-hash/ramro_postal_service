class AcceptOrderRequest {
  final int order_id;

  const AcceptOrderRequest({required this.order_id});

  factory AcceptOrderRequest.fromJson(Map<String, dynamic> json) {
    return AcceptOrderRequest(order_id: json['order_id'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'order_id': order_id};
  }
}

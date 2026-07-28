class SubscribeRequest {
  final int package_id;

  const SubscribeRequest({required this.package_id});

  factory SubscribeRequest.fromJson(Map<String, dynamic> json) {
    return SubscribeRequest(package_id: json['package_id'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'package_id': package_id};
  }
}

import 'order.dart';

class OrderDetailsResponse extends Order {
  bool? success;
  Order? order;

  OrderDetailsResponse({this.success, this.order});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
}

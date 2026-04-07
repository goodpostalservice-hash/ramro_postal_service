import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order.dart';

class PlaceOrderResponse extends Equatable {
  final bool? success;
  final String? message;
  final Order? order;

  const PlaceOrderResponse({this.success, this.message, this.order});

  factory PlaceOrderResponse.fromMap(Map<String, dynamic> data) {
    return PlaceOrderResponse(
      success: data['success'] as bool?,
      message: data['message'] as String?,
      order: data['order'] == null
          ? null
          : Order.fromMap(data['order'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'message': message,
    'order': order?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PlaceOrderResponse].
  factory PlaceOrderResponse.fromJson(String data) {
    return PlaceOrderResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [PlaceOrderResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  PlaceOrderResponse copyWith({bool? success, String? message, Order? order}) {
    return PlaceOrderResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      order: order ?? this.order,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, message, order];
}

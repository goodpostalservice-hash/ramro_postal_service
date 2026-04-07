import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order.dart';

class OrderDetailResponse extends Equatable {
  final bool? success;
  final Order? order;

  const OrderDetailResponse({this.success, this.order});

  factory OrderDetailResponse.fromMap(Map<String, dynamic> data) {
    return OrderDetailResponse(
      success: data['success'] as bool?,
      order: data['order'] == null
          ? null
          : Order.fromMap(data['order'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'success': success, 'order': order?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderDetailResponse].
  factory OrderDetailResponse.fromJson(String data) {
    return OrderDetailResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [OrderDetailResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderDetailResponse copyWith({bool? success, Order? order}) {
    return OrderDetailResponse(
      success: success ?? this.success,
      order: order ?? this.order,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, order];
}

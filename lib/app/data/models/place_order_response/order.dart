import 'dart:convert';

import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int? userId;
  final String? receiverName;
  final String? receiverPhone;
  final String? totalAmount;
  final String? payeer;
  final String? senderLongitude;
  final String? senderLatitude;
  final String? senderCoordinates;
  final String? receiverLongitude;
  final String? receiverLatitude;
  final String? receiverCoordinates;
  final String? paymentMethod;
  final String? deliveryScope;
  final String? vechicleType;
  final String? orderUuid;
  final String? trackingNumber;
  final String? status;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  const Order({
    this.userId,
    this.receiverName,
    this.receiverPhone,
    this.totalAmount,
    this.payeer,
    this.senderLongitude,
    this.senderLatitude,
    this.senderCoordinates,
    this.receiverLongitude,
    this.receiverLatitude,
    this.receiverCoordinates,
    this.paymentMethod,
    this.deliveryScope,
    this.vechicleType,
    this.orderUuid,
    this.trackingNumber,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Order.fromMap(Map<String, dynamic> data) => Order(
    userId: data['user_id'] as int?,
    receiverName: data['receiver_name'] as String?,
    receiverPhone: data['receiver_phone'] as String?,
    totalAmount: data['total_amount'] as String?,
    payeer: data['payeer'] as String?,
    senderLongitude: data['sender_longitude'] as String?,
    senderLatitude: data['sender_latitude'] as String?,
    senderCoordinates: data['sender_coordinates'] as String?,
    receiverLongitude: data['receiver_longitude'] as String?,
    receiverLatitude: data['receiver_latitude'] as String?,
    receiverCoordinates: data['receiver_coordinates'] as String?,
    paymentMethod: data['payment_method'] as String?,
    deliveryScope: data['delivery_scope'] as String?,
    vechicleType: data['vechicle_type'] as String?,
    orderUuid: data['order_uuid'] as String?,
    trackingNumber: data['tracking_number'] as String?,
    status: data['status'] as String?,
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
    createdAt: data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String),
    id: data['id'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'receiver_name': receiverName,
    'receiver_phone': receiverPhone,
    'total_amount': totalAmount,
    'payeer': payeer,
    'sender_longitude': senderLongitude,
    'sender_latitude': senderLatitude,
    'sender_coordinates': senderCoordinates,
    'receiver_longitude': receiverLongitude,
    'receiver_latitude': receiverLatitude,
    'receiver_coordinates': receiverCoordinates,
    'payment_method': paymentMethod,
    'delivery_scope': deliveryScope,
    'vechicle_type': vechicleType,
    'order_uuid': orderUuid,
    'tracking_number': trackingNumber,
    'status': status,
    'updated_at': updatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'id': id,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Order].
  factory Order.fromJson(String data) {
    return Order.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Order] to a JSON string.
  String toJson() => json.encode(toMap());

  Order copyWith({
    int? userId,
    String? receiverName,
    String? receiverPhone,
    String? totalAmount,
    String? payeer,
    String? senderLongitude,
    String? senderLatitude,
    String? senderCoordinates,
    String? receiverLongitude,
    String? receiverLatitude,
    String? receiverCoordinates,
    String? paymentMethod,
    String? deliveryScope,
    String? vechicleType,
    String? orderUuid,
    String? trackingNumber,
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? id,
  }) {
    return Order(
      userId: userId ?? this.userId,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      totalAmount: totalAmount ?? this.totalAmount,
      payeer: payeer ?? this.payeer,
      senderLongitude: senderLongitude ?? this.senderLongitude,
      senderLatitude: senderLatitude ?? this.senderLatitude,
      senderCoordinates: senderCoordinates ?? this.senderCoordinates,
      receiverLongitude: receiverLongitude ?? this.receiverLongitude,
      receiverLatitude: receiverLatitude ?? this.receiverLatitude,
      receiverCoordinates: receiverCoordinates ?? this.receiverCoordinates,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryScope: deliveryScope ?? this.deliveryScope,
      vechicleType: vechicleType ?? this.vechicleType,
      orderUuid: orderUuid ?? this.orderUuid,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      userId,
      receiverName,
      receiverPhone,
      totalAmount,
      payeer,
      senderLongitude,
      senderLatitude,
      senderCoordinates,
      receiverLongitude,
      receiverLatitude,
      receiverCoordinates,
      paymentMethod,
      deliveryScope,
      vechicleType,
      orderUuid,
      trackingNumber,
      status,
      updatedAt,
      createdAt,
      id,
    ];
  }
}

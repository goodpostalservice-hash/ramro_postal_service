import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user.dart';

class Order extends Equatable {
  final int? id;
  final String? orderUuid;
  final int? driverId;
  final int? userId;
  final dynamic marchentId;
  final String? receiverName;
  final String? receiverPhone;
  final dynamic shippingAddress;
  final String? totalAmount;
  final dynamic additionalNotes;
  final dynamic orderCategory;
  final String? payeer;
  final String? senderLongitude;
  final String? senderLatitude;
  final String? senderCoordinates;
  final dynamic pickupLocation;
  final String? receiverLongitude;
  final String? receiverLatitude;
  final String? receiverCoordinates;
  final dynamic deliveryLocation;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? deliveryType;
  final String? deliveryScope;
  final dynamic scheduledPickupTime;
  final dynamic scheduledDeliveryTime;
  final String? orderPriority;
  final String? fragileHandling;
  final String? vechicleType;
  final String? trackingNumber;
  final dynamic couponCode;
  final String? discountAmount;
  final String? taxAmount;
  final String? deliveryFee;
  final dynamic orderQrcode;
  final String? status;
  final dynamic remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  const Order({
    this.id,
    this.orderUuid,
    this.driverId,
    this.userId,
    this.marchentId,
    this.receiverName,
    this.receiverPhone,
    this.shippingAddress,
    this.totalAmount,
    this.additionalNotes,
    this.orderCategory,
    this.payeer,
    this.senderLongitude,
    this.senderLatitude,
    this.senderCoordinates,
    this.pickupLocation,
    this.receiverLongitude,
    this.receiverLatitude,
    this.receiverCoordinates,
    this.deliveryLocation,
    this.paymentMethod,
    this.paymentStatus,
    this.deliveryType,
    this.deliveryScope,
    this.scheduledPickupTime,
    this.scheduledDeliveryTime,
    this.orderPriority,
    this.fragileHandling,
    this.vechicleType,
    this.trackingNumber,
    this.couponCode,
    this.discountAmount,
    this.taxAmount,
    this.deliveryFee,
    this.orderQrcode,
    this.status,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Order.fromMap(Map<String, dynamic> data) => Order(
    id: data['id'] as int?,
    orderUuid: data['order_uuid'] as String?,
    driverId: data['driver_id'] as int?,
    userId: data['user_id'] as int?,
    marchentId: data['marchent_id'] as dynamic,
    receiverName: data['receiver_name'] as String?,
    receiverPhone: data['receiver_phone'] as String?,
    shippingAddress: data['shipping_address'] as dynamic,
    totalAmount: data['total_amount'] as String?,
    additionalNotes: data['additional_notes'] as dynamic,
    orderCategory: data['order_category'] as dynamic,
    payeer: data['payeer'] as String?,
    senderLongitude: data['sender_longitude'] as String?,
    senderLatitude: data['sender_latitude'] as String?,
    senderCoordinates: data['sender_coordinates'] as String?,
    pickupLocation: data['pickup_location'] as dynamic,
    receiverLongitude: data['receiver_longitude'] as String?,
    receiverLatitude: data['receiver_latitude'] as String?,
    receiverCoordinates: data['receiver_coordinates'] as String?,
    deliveryLocation: data['delivery_location'] as dynamic,
    paymentMethod: data['payment_method'] as String?,
    paymentStatus: data['payment_status'] as String?,
    deliveryType: data['delivery_type'] as String?,
    deliveryScope: data['delivery_scope'] as String?,
    scheduledPickupTime: data['scheduled_pickup_time'] as dynamic,
    scheduledDeliveryTime: data['scheduled_delivery_time'] as dynamic,
    orderPriority: data['order_priority'] as String?,
    fragileHandling: data['fragile_handling'] as String?,
    vechicleType: data['vechicle_type'] as String?,
    trackingNumber: data['tracking_number'] as String?,
    couponCode: data['coupon_code'] as dynamic,
    discountAmount: data['discount_amount'] as String?,
    taxAmount: data['tax_amount'] as String?,
    deliveryFee: data['delivery_fee'] as String?,
    orderQrcode: data['order_qrcode'] as dynamic,
    status: data['status'] as String?,
    remarks: data['remarks'] as dynamic,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
    user: data['user'] == null
        ? null
        : User.fromMap(data['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'order_uuid': orderUuid,
    'driver_id': driverId,
    'user_id': userId,
    'marchent_id': marchentId,
    'receiver_name': receiverName,
    'receiver_phone': receiverPhone,
    'shipping_address': shippingAddress,
    'total_amount': totalAmount,
    'additional_notes': additionalNotes,
    'order_category': orderCategory,
    'payeer': payeer,
    'sender_longitude': senderLongitude,
    'sender_latitude': senderLatitude,
    'sender_coordinates': senderCoordinates,
    'pickup_location': pickupLocation,
    'receiver_longitude': receiverLongitude,
    'receiver_latitude': receiverLatitude,
    'receiver_coordinates': receiverCoordinates,
    'delivery_location': deliveryLocation,
    'payment_method': paymentMethod,
    'payment_status': paymentStatus,
    'delivery_type': deliveryType,
    'delivery_scope': deliveryScope,
    'scheduled_pickup_time': scheduledPickupTime,
    'scheduled_delivery_time': scheduledDeliveryTime,
    'order_priority': orderPriority,
    'fragile_handling': fragileHandling,
    'vechicle_type': vechicleType,
    'tracking_number': trackingNumber,
    'coupon_code': couponCode,
    'discount_amount': discountAmount,
    'tax_amount': taxAmount,
    'delivery_fee': deliveryFee,
    'order_qrcode': orderQrcode,
    'status': status,
    'remarks': remarks,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'user': user?.toMap(),
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
    int? id,
    String? orderUuid,
    int? driverId,
    int? userId,
    dynamic marchentId,
    String? receiverName,
    String? receiverPhone,
    dynamic shippingAddress,
    String? totalAmount,
    dynamic additionalNotes,
    dynamic orderCategory,
    String? payeer,
    String? senderLongitude,
    String? senderLatitude,
    String? senderCoordinates,
    dynamic pickupLocation,
    String? receiverLongitude,
    String? receiverLatitude,
    String? receiverCoordinates,
    dynamic deliveryLocation,
    String? paymentMethod,
    String? paymentStatus,
    String? deliveryType,
    String? deliveryScope,
    dynamic scheduledPickupTime,
    dynamic scheduledDeliveryTime,
    String? orderPriority,
    String? fragileHandling,
    String? vechicleType,
    String? trackingNumber,
    dynamic couponCode,
    String? discountAmount,
    String? taxAmount,
    String? deliveryFee,
    dynamic orderQrcode,
    String? status,
    dynamic remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Order(
      id: id ?? this.id,
      orderUuid: orderUuid ?? this.orderUuid,
      driverId: driverId ?? this.driverId,
      userId: userId ?? this.userId,
      marchentId: marchentId ?? this.marchentId,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      orderCategory: orderCategory ?? this.orderCategory,
      payeer: payeer ?? this.payeer,
      senderLongitude: senderLongitude ?? this.senderLongitude,
      senderLatitude: senderLatitude ?? this.senderLatitude,
      senderCoordinates: senderCoordinates ?? this.senderCoordinates,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      receiverLongitude: receiverLongitude ?? this.receiverLongitude,
      receiverLatitude: receiverLatitude ?? this.receiverLatitude,
      receiverCoordinates: receiverCoordinates ?? this.receiverCoordinates,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryScope: deliveryScope ?? this.deliveryScope,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      scheduledDeliveryTime:
          scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      orderPriority: orderPriority ?? this.orderPriority,
      fragileHandling: fragileHandling ?? this.fragileHandling,
      vechicleType: vechicleType ?? this.vechicleType,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      couponCode: couponCode ?? this.couponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      orderQrcode: orderQrcode ?? this.orderQrcode,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      orderUuid,
      driverId,
      userId,
      marchentId,
      receiverName,
      receiverPhone,
      shippingAddress,
      totalAmount,
      additionalNotes,
      orderCategory,
      payeer,
      senderLongitude,
      senderLatitude,
      senderCoordinates,
      pickupLocation,
      receiverLongitude,
      receiverLatitude,
      receiverCoordinates,
      deliveryLocation,
      paymentMethod,
      paymentStatus,
      deliveryType,
      deliveryScope,
      scheduledPickupTime,
      scheduledDeliveryTime,
      orderPriority,
      fragileHandling,
      vechicleType,
      trackingNumber,
      couponCode,
      discountAmount,
      taxAmount,
      deliveryFee,
      orderQrcode,
      status,
      remarks,
      createdAt,
      updatedAt,
      user,
    ];
  }
}

class AvailableOrderModel {
  final int id;
  final String orderUuid;
  final int? driverId;
  final int userId;
  final int? merchantId;
  final String receiverName;
  final String receiverPhone;
  final String? shippingAddress;
  final String totalAmount;
  final String? additionalNotes;
  final String? orderCategory;
  final String payeer;
  final String senderLongitude;
  final String senderLatitude;
  final String senderCoordinates;
  final String? pickupLocation;
  final String receiverLongitude;
  final String receiverLatitude;
  final String receiverCoordinates;
  final String? deliveryLocation;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryType;
  final String deliveryScope;
  final String? scheduledPickupTime;
  final String? scheduledDeliveryTime;
  final String orderPriority;
  final String fragileHandling;
  final String vehicleType;
  final String trackingNumber;
  final String? couponCode;
  final String discountAmount;
  final String taxAmount;
  final String deliveryFee;
  final String? orderQrcode;
  final String status;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  AvailableOrderModel({
    required this.id,
    required this.orderUuid,
    this.driverId,
    required this.userId,
    this.merchantId,
    required this.receiverName,
    required this.receiverPhone,
    this.shippingAddress,
    required this.totalAmount,
    this.additionalNotes,
    this.orderCategory,
    required this.payeer,
    required this.senderLongitude,
    required this.senderLatitude,
    required this.senderCoordinates,
    this.pickupLocation,
    required this.receiverLongitude,
    required this.receiverLatitude,
    required this.receiverCoordinates,
    this.deliveryLocation,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryType,
    required this.deliveryScope,
    this.scheduledPickupTime,
    this.scheduledDeliveryTime,
    required this.orderPriority,
    required this.fragileHandling,
    required this.vehicleType,
    required this.trackingNumber,
    this.couponCode,
    required this.discountAmount,
    required this.taxAmount,
    required this.deliveryFee,
    this.orderQrcode,
    required this.status,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AvailableOrderModel.fromJson(Map<String, dynamic> json) {
    return AvailableOrderModel(
      id: json['id'] as int,
      orderUuid: json['order_uuid'] as String,
      driverId: json['driver_id'] as int?,
      userId: json['user_id'] as int,
      merchantId: json['marchent_id'] as int?,
      receiverName: json['receiver_name'] as String,
      receiverPhone: json['receiver_phone'] as String,
      shippingAddress: json['shipping_address'] as String?,
      totalAmount: json['total_amount'] as String,
      additionalNotes: json['additional_notes'] as String?,
      orderCategory: json['order_category'] as String?,
      payeer: json['payeer'] as String,
      senderLongitude: json['sender_longitude'] as String,
      senderLatitude: json['sender_latitude'] as String,
      senderCoordinates: json['sender_coordinates'] as String,
      pickupLocation: json['pickup_location'] as String?,
      receiverLongitude: json['receiver_longitude'] as String,
      receiverLatitude: json['receiver_latitude'] as String,
      receiverCoordinates: json['receiver_coordinates'] as String,
      deliveryLocation: json['delivery_location'] as String?,
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      deliveryType: json['delivery_type'] as String,
      deliveryScope: json['delivery_scope'] as String,
      scheduledPickupTime: json['scheduled_pickup_time'] as String?,
      scheduledDeliveryTime: json['scheduled_delivery_time'] as String?,
      orderPriority: json['order_priority'] as String,
      fragileHandling: json['fragile_handling'] as String,
      vehicleType: json['vechicle_type'] as String,
      trackingNumber: json['tracking_number'] as String,
      couponCode: json['coupon_code'] as String?,
      discountAmount: json['discount_amount'] as String,
      taxAmount: json['tax_amount'] as String,
      deliveryFee: json['delivery_fee'] as String,
      orderQrcode: json['order_qrcode'] as String?,
      status: json['status'] as String,
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_uuid': orderUuid,
      'driver_id': driverId,
      'user_id': userId,
      'marchent_id': merchantId,
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
      'vechicle_type': vehicleType,
      'tracking_number': trackingNumber,
      'coupon_code': couponCode,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'delivery_fee': deliveryFee,
      'order_qrcode': orderQrcode,
      'status': status,
      'remarks': remarks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

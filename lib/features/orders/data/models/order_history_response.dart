class OrderHistoryResponse {
  bool? success;
  List<Orders>? orders;

  OrderHistoryResponse({this.success, this.orders});

  OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }
}

class Orders {
  int? id;
  String? orderUuid;
  int? driverId;
  int? userId;
  String? marchentId;
  String? receiverName;
  String? receiverPhone;
  String? shippingAddress;
  String? totalAmount;
  String? additionalNotes;
  String? orderCategory;
  String? payeer;
  String? senderLongitude;
  String? senderLatitude;
  String? senderCoordinates;
  String? pickupLocation;
  String? receiverLongitude;
  String? receiverLatitude;
  String? receiverCoordinates;
  String? deliveryLocation;
  String? paymentMethod;
  String? paymentStatus;
  String? deliveryType;
  String? deliveryScope;
  String? scheduledPickupTime;
  String? scheduledDeliveryTime;
  String? orderPriority;
  String? fragileHandling;
  String? vechicleType;
  String? trackingNumber;
  String? couponCode;
  String? discountAmount;
  String? taxAmount;
  String? deliveryFee;
  String? orderQrcode;
  String? status;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  Orders({
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
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderUuid = json['order_uuid'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    marchentId = json['marchent_id'];
    receiverName = json['receiver_name'];
    receiverPhone = json['receiver_phone'];
    shippingAddress = json['shipping_address'];
    totalAmount = json['total_amount'];
    additionalNotes = json['additional_notes'];
    orderCategory = json['order_category'];
    payeer = json['payeer'];
    senderLongitude = json['sender_longitude'];
    senderLatitude = json['sender_latitude'];
    senderCoordinates = json['sender_coordinates'];
    pickupLocation = json['pickup_location'];
    receiverLongitude = json['receiver_longitude'];
    receiverLatitude = json['receiver_latitude'];
    receiverCoordinates = json['receiver_coordinates'];
    deliveryLocation = json['delivery_location'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    deliveryType = json['delivery_type'];
    deliveryScope = json['delivery_scope'];
    scheduledPickupTime = json['scheduled_pickup_time'];
    scheduledDeliveryTime = json['scheduled_delivery_time'];
    orderPriority = json['order_priority'];
    fragileHandling = json['fragile_handling'];
    vechicleType = json['vechicle_type'];
    trackingNumber = json['tracking_number'];
    couponCode = json['coupon_code'];
    discountAmount = json['discount_amount'];
    taxAmount = json['tax_amount'];
    deliveryFee = json['delivery_fee'];
    orderQrcode = json['order_qrcode'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

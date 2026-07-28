class Order {
  int? id;
  String? orderUuid;
  int? driverId;
  int? userId;
  Null marchentId;
  String? receiverName;
  String? receiverPhone;
  Null shippingAddress;
  String? totalAmount;
  Null additionalNotes;
  Null orderCategory;
  String? payeer;
  String? senderLongitude;
  String? senderLatitude;
  String? senderCoordinates;
  Null pickupLocation;
  String? receiverLongitude;
  String? receiverLatitude;
  String? receiverCoordinates;
  Null deliveryLocation;
  String? paymentMethod;
  String? paymentStatus;
  String? deliveryType;
  String? deliveryScope;
  Null scheduledPickupTime;
  Null scheduledDeliveryTime;
  String? orderPriority;
  String? fragileHandling;
  String? vechicleType;
  String? trackingNumber;
  Null couponCode;
  String? discountAmount;
  String? taxAmount;
  String? deliveryFee;
  Null orderQrcode;
  String? status;
  Null remarks;
  String? createdAt;
  String? updatedAt;
  User? user;

  Order({
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

  Order.fromJson(Map<String, dynamic> json) {
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_uuid'] = orderUuid;
    data['driver_id'] = driverId;
    data['user_id'] = userId;
    data['marchent_id'] = marchentId;
    data['receiver_name'] = receiverName;
    data['receiver_phone'] = receiverPhone;
    data['shipping_address'] = shippingAddress;
    data['total_amount'] = totalAmount;
    data['additional_notes'] = additionalNotes;
    data['order_category'] = orderCategory;
    data['payeer'] = payeer;
    data['sender_longitude'] = senderLongitude;
    data['sender_latitude'] = senderLatitude;
    data['sender_coordinates'] = senderCoordinates;
    data['pickup_location'] = pickupLocation;
    data['receiver_longitude'] = receiverLongitude;
    data['receiver_latitude'] = receiverLatitude;
    data['receiver_coordinates'] = receiverCoordinates;
    data['delivery_location'] = deliveryLocation;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['delivery_type'] = deliveryType;
    data['delivery_scope'] = deliveryScope;
    data['scheduled_pickup_time'] = scheduledPickupTime;
    data['scheduled_delivery_time'] = scheduledDeliveryTime;
    data['order_priority'] = orderPriority;
    data['fragile_handling'] = fragileHandling;
    data['vechicle_type'] = vechicleType;
    data['tracking_number'] = trackingNumber;
    data['coupon_code'] = couponCode;
    data['discount_amount'] = discountAmount;
    data['tax_amount'] = taxAmount;
    data['delivery_fee'] = deliveryFee;
    data['order_qrcode'] = orderQrcode;
    data['status'] = status;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? uuid;
  String? firstName;
  Null lastName;
  Null image;
  Null email;
  Null emailVerifiedAt;
  String? countryCode;
  String? phone;
  int? isPhoneVerified;
  String? currentLatitude;
  String? currentLongitude;
  String? currentCoordinates;
  String? lastCoordinates;
  String? lastLatitude;
  String? lastLongitude;
  String? ipAddress;
  String? lastLoginIp;
  String? lastLoginAt;
  String? userType;
  int? isOnline;
  String? status;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.uuid,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.emailVerifiedAt,
    this.countryCode,
    this.phone,
    this.isPhoneVerified,
    this.currentLatitude,
    this.currentLongitude,
    this.currentCoordinates,
    this.lastCoordinates,
    this.lastLatitude,
    this.lastLongitude,
    this.ipAddress,
    this.lastLoginIp,
    this.lastLoginAt,
    this.userType,
    this.isOnline,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    isPhoneVerified = json['isPhoneVerified'];
    currentLatitude = json['current_latitude'];
    currentLongitude = json['current_longitude'];
    currentCoordinates = json['current_coordinates'];
    lastCoordinates = json['last_coordinates'];
    lastLatitude = json['last_latitude'];
    lastLongitude = json['last_longitude'];
    ipAddress = json['ip_address'];
    lastLoginIp = json['last_login_ip'];
    lastLoginAt = json['last_login_at'];
    userType = json['user_type'];
    isOnline = json['is_online'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['isPhoneVerified'] = isPhoneVerified;
    data['current_latitude'] = currentLatitude;
    data['current_longitude'] = currentLongitude;
    data['current_coordinates'] = currentCoordinates;
    data['last_coordinates'] = lastCoordinates;
    data['last_latitude'] = lastLatitude;
    data['last_longitude'] = lastLongitude;
    data['ip_address'] = ipAddress;
    data['last_login_ip'] = lastLoginIp;
    data['last_login_at'] = lastLoginAt;
    data['user_type'] = userType;
    data['is_online'] = isOnline;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

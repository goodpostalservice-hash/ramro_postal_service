import 'package:dio/dio.dart';

class PlaceOrderParam {
  final String userId;
  final String receiverName;
  final String receiverPhone;
  final String payeer;
  final String senderLatitude;
  final String senderLongitude;
  final String senderCoordinates;
  final String receiverLatitude;
  final String receiverLongitude;
  final String receiverCoordinates;
  final String paymentMethod;
  final String totalAmount;
  final String deliveryScope;
  final String vehicleType;

  PlaceOrderParam({
    required this.userId,
    required this.receiverName,
    required this.receiverPhone,
    required this.payeer,
    required this.senderLatitude,
    required this.senderLongitude,
    required this.senderCoordinates,
    required this.receiverLatitude,
    required this.receiverLongitude,
    required this.receiverCoordinates,
    required this.paymentMethod,
    required this.totalAmount,
    required this.deliveryScope,
    required this.vehicleType,
  });


  Map<String, String> toMap() {
    return {
      'user_id': userId,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'payeer': payeer,
      'sender_latitude': senderLatitude,
      'sender_longitude': senderLongitude,
      'sender_coordinates': senderCoordinates,
      'receiver_latitude': receiverLatitude,
      'receiver_longitude': receiverLongitude,
      'receiver_coordinates': receiverCoordinates,
      'payment_method': paymentMethod,
      'total_amount': totalAmount,
      'delivery_scope': deliveryScope,
      'vechicle_type': vehicleType, 
    };
  }

  /// If you are using the Dio package for your API calls
  FormData toFormData() {
    return FormData.fromMap(toMap());
  }
}
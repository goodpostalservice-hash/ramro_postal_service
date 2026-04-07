import 'dart:convert';

import 'package:equatable/equatable.dart';

class EstimateCostParam extends Equatable {
  final String? senderLongitude;
  final String? senderLatitude;
  final String? receiverLongitude;
  final String? receiverLatitude;
  final String? vehicleType;
  final String? deliveryScope;

  const EstimateCostParam({
    this.senderLongitude,
    this.senderLatitude,
    this.receiverLongitude,
    this.receiverLatitude,
    this.vehicleType,
    this.deliveryScope,
  });

  factory EstimateCostParam.fromMap(Map<String, dynamic> data) {
    return EstimateCostParam(
      senderLongitude: data['sender_longitude'] as String?,
      senderLatitude: data['sender_latitude'] as String?,
      receiverLongitude: data['receiver_longitude'] as String?,
      receiverLatitude: data['receiver_latitude'] as String?,
      vehicleType: data['vehicle_type'] as String?,
      deliveryScope: data['delivery_scope'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'sender_longitude': senderLongitude,
    'sender_latitude': senderLatitude,
    'receiver_longitude': receiverLongitude,
    'receiver_latitude': receiverLatitude,
    'vehicle_type': vehicleType,
    'delivery_scope': deliveryScope,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EstimateCostParam].
  factory EstimateCostParam.fromJson(String data) {
    return EstimateCostParam.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EstimateCostParam] to a JSON string.
  String toJson() => json.encode(toMap());

  EstimateCostParam copyWith({
    String? senderLongitude,
    String? senderLatitude,
    String? receiverLongitude,
    String? receiverLatitude,
    String? vehicleType,
    String? deliveryScope,
  }) {
    return EstimateCostParam(
      senderLongitude: senderLongitude ?? this.senderLongitude,
      senderLatitude: senderLatitude ?? this.senderLatitude,
      receiverLongitude: receiverLongitude ?? this.receiverLongitude,
      receiverLatitude: receiverLatitude ?? this.receiverLatitude,
      vehicleType: vehicleType ?? this.vehicleType,
      deliveryScope: deliveryScope ?? this.deliveryScope,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      senderLongitude,
      senderLatitude,
      receiverLongitude,
      receiverLatitude,
      vehicleType,
      deliveryScope,
    ];
  }
}

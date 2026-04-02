import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'subscription.dart';

class MySubscriptionResponse extends Equatable {
  final bool? success;
  final Subscription? subscription;

  const MySubscriptionResponse({this.success, this.subscription});

  factory MySubscriptionResponse.fromMap(Map<String, dynamic> data) {
    return MySubscriptionResponse(
      success: data['success'] as bool?,
      subscription: data['subscription'] == null
          ? null
          : Subscription.fromMap(data['subscription'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'subscription': subscription?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MySubscriptionResponse].
  factory MySubscriptionResponse.fromJson(String data) {
    return MySubscriptionResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [MySubscriptionResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  MySubscriptionResponse copyWith({bool? success, Subscription? subscription}) {
    return MySubscriptionResponse(
      success: success ?? this.success,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, subscription];
}

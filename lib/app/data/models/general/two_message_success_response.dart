import 'dart:convert';

import 'package:equatable/equatable.dart';

class TwoMessageSuccessResponse extends Equatable {
  final bool? success;
  final String? message;
  final String? phoneNumber;

  const TwoMessageSuccessResponse({
    this.success,
    this.message,
    this.phoneNumber,
  });

  factory TwoMessageSuccessResponse.fromMap(Map<String, dynamic> data) {
    return TwoMessageSuccessResponse(
      success: data['success'] as bool?,
      message: data['message'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'message': message,
    'phoneNumber': phoneNumber,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TwoMessageSuccessResponse].
  factory TwoMessageSuccessResponse.fromJson(String data) {
    return TwoMessageSuccessResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [TwoMessageSuccessResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  TwoMessageSuccessResponse copyWith({
    bool? success,
    String? message,
    String? phoneNumber,
  }) {
    return TwoMessageSuccessResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, message, phoneNumber];
}

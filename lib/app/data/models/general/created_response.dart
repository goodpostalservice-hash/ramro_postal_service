import 'dart:convert';

import 'package:equatable/equatable.dart';

class CreatedResponse extends Equatable {
  final bool? success;
  final String? message;

  const CreatedResponse({this.success, this.message});

  factory CreatedResponse.fromMap(Map<String, dynamic> data) {
    return CreatedResponse(
      success: data['success'] as bool?,
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'success': success,
        'message': message,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CreatedResponse].
  factory CreatedResponse.fromJson(String data) {
    return CreatedResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CreatedResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  CreatedResponse copyWith({
    bool? success,
    String? message,
  }) {
    return CreatedResponse(
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, message];
}

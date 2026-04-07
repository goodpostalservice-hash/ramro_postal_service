import 'dart:convert';

import 'package:equatable/equatable.dart';

class SingleMessageResponse extends Equatable {
  final String? message;

  const SingleMessageResponse({this.message});

  factory SingleMessageResponse.fromMap(Map<String, dynamic> data) {
    return SingleMessageResponse(message: data['message'] as String?);
  }

  Map<String, dynamic> toMap() => {'message': message};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SingleMessageResponse].
  factory SingleMessageResponse.fromJson(String data) {
    return SingleMessageResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [SingleMessageResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  SingleMessageResponse copyWith({String? message}) {
    return SingleMessageResponse(message: message ?? this.message);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [message];
}

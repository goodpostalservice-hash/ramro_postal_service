import 'dart:convert';

import 'package:equatable/equatable.dart';

class EarningResponse extends Equatable {
  final bool? success;
  final int? earnings;

  const EarningResponse({this.success, this.earnings});

  factory EarningResponse.fromMap(Map<String, dynamic> data) {
    return EarningResponse(
      success: data['success'] as bool?,
      earnings: data['earnings'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {'success': success, 'earnings': earnings};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EarningResponse].
  factory EarningResponse.fromJson(String data) {
    return EarningResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EarningResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  EarningResponse copyWith({bool? success, int? earnings}) {
    return EarningResponse(
      success: success ?? this.success,
      earnings: earnings ?? this.earnings,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, earnings];
}

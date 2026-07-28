import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodayEarningResponse extends Equatable {
  final bool? success;
  final int? todayEarnings;

  const TodayEarningResponse({this.success, this.todayEarnings});

  factory TodayEarningResponse.fromMap(Map<String, dynamic> data) {
    return TodayEarningResponse(
      success: data['success'] as bool?,
      todayEarnings: data['today_earnings'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'today_earnings': todayEarnings,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TodayEarningResponse].
  factory TodayEarningResponse.fromJson(String data) {
    return TodayEarningResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [TodayEarningResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  TodayEarningResponse copyWith({bool? success, int? todayEarnings}) {
    return TodayEarningResponse(
      success: success ?? this.success,
      todayEarnings: todayEarnings ?? this.todayEarnings,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, todayEarnings];
}

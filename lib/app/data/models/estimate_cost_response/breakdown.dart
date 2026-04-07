import 'dart:convert';

import 'package:equatable/equatable.dart';

class Breakdown extends Equatable {
  final int? baseFare;
  final int? distanceCharge;
  final int? timeCharge;
  final double? distanceKm;
  final int? estimatedTimeMinutes;

  const Breakdown({
    this.baseFare,
    this.distanceCharge,
    this.timeCharge,
    this.distanceKm,
    this.estimatedTimeMinutes,
  });

  factory Breakdown.fromMap(Map<String, dynamic> data) => Breakdown(
    baseFare: data['base_fare'] as int?,
    distanceCharge: data['distance_charge'] as int?,
    timeCharge: data['time_charge'] as int?,
    distanceKm: (data['distance_km'] as num?)?.toDouble(),
    estimatedTimeMinutes: data['estimated_time_minutes'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'base_fare': baseFare,
    'distance_charge': distanceCharge,
    'time_charge': timeCharge,
    'distance_km': distanceKm,
    'estimated_time_minutes': estimatedTimeMinutes,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Breakdown].
  factory Breakdown.fromJson(String data) {
    return Breakdown.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Breakdown] to a JSON string.
  String toJson() => json.encode(toMap());

  Breakdown copyWith({
    int? baseFare,
    int? distanceCharge,
    int? timeCharge,
    double? distanceKm,
    int? estimatedTimeMinutes,
  }) {
    return Breakdown(
      baseFare: baseFare ?? this.baseFare,
      distanceCharge: distanceCharge ?? this.distanceCharge,
      timeCharge: timeCharge ?? this.timeCharge,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      baseFare,
      distanceCharge,
      timeCharge,
      distanceKm,
      estimatedTimeMinutes,
    ];
  }
}

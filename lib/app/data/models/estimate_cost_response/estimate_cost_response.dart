import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'breakdown.dart';

class EstimateCostResponse extends Equatable {
  final int? estimatedCost;
  final String? currency;
  final double? distanceKm;
  final int? estimatedTimeMinutes;
  final Breakdown? breakdown;

  const EstimateCostResponse({
    this.estimatedCost,
    this.currency,
    this.distanceKm,
    this.estimatedTimeMinutes,
    this.breakdown,
  });

  factory EstimateCostResponse.fromMap(Map<String, dynamic> data) {
    return EstimateCostResponse(
      estimatedCost: data['estimated_cost'] as int?,
      currency: data['currency'] as String?,
      distanceKm: (data['distance_km'] as num?)?.toDouble(),
      estimatedTimeMinutes: data['estimated_time_minutes'] as int?,
      breakdown: data['breakdown'] == null
          ? null
          : Breakdown.fromMap(data['breakdown'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'estimated_cost': estimatedCost,
    'currency': currency,
    'distance_km': distanceKm,
    'estimated_time_minutes': estimatedTimeMinutes,
    'breakdown': breakdown?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EstimateCostResponse].
  factory EstimateCostResponse.fromJson(String data) {
    return EstimateCostResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [EstimateCostResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  EstimateCostResponse copyWith({
    int? estimatedCost,
    String? currency,
    double? distanceKm,
    int? estimatedTimeMinutes,
    Breakdown? breakdown,
  }) {
    return EstimateCostResponse(
      estimatedCost: estimatedCost ?? this.estimatedCost,
      currency: currency ?? this.currency,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      estimatedCost,
      currency,
      distanceKm,
      estimatedTimeMinutes,
      breakdown,
    ];
  }
}

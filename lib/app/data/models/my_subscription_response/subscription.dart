import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package.dart';

class Subscription extends Equatable {
  final int? id;
  final int? userId;
  final int? packageId;
  final int? availableTokens;
  final DateTime? validUntil;
  final dynamic remarks;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Package? package;

  const Subscription({
    this.id,
    this.userId,
    this.packageId,
    this.availableTokens,
    this.validUntil,
    this.remarks,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.package,
  });

  factory Subscription.fromMap(Map<String, dynamic> data) => Subscription(
    id: data['id'] as int?,
    userId: data['user_id'] as int?,
    packageId: data['package_id'] as int?,
    availableTokens: data['available_tokens'] as int?,
    validUntil: data['valid_until'] == null
        ? null
        : DateTime.parse(data['valid_until'] as String),
    remarks: data['remarks'] as dynamic,
    status: data['status'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
    package: data['package'] == null
        ? null
        : Package.fromMap(data['package'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'package_id': packageId,
    'available_tokens': availableTokens,
    'valid_until': validUntil?.toIso8601String(),
    'remarks': remarks,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'package': package?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Subscription].
  factory Subscription.fromJson(String data) {
    return Subscription.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Subscription] to a JSON string.
  String toJson() => json.encode(toMap());

  Subscription copyWith({
    int? id,
    int? userId,
    int? packageId,
    int? availableTokens,
    DateTime? validUntil,
    dynamic remarks,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Package? package,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      packageId: packageId ?? this.packageId,
      availableTokens: availableTokens ?? this.availableTokens,
      validUntil: validUntil ?? this.validUntil,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      package: package ?? this.package,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      packageId,
      availableTokens,
      validUntil,
      remarks,
      status,
      createdAt,
      updatedAt,
      package,
    ];
  }
}

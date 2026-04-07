import 'dart:convert';

import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final int? id;
  final int? userId;
  final String? userType;
  final int? avilableTokens;
  final int? usedTokens;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Wallet({
    this.id,
    this.userId,
    this.userType,
    this.avilableTokens,
    this.usedTokens,
    this.createdAt,
    this.updatedAt,
  });

  factory Wallet.fromMap(Map<String, dynamic> data) => Wallet(
    id: data['id'] as int?,
    userId: data['user_id'] as int?,
    userType: data['user_type'] as String?,
    avilableTokens: data['avilable_tokens'] as int?,
    usedTokens: data['used_tokens'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'user_type': userType,
    'avilable_tokens': avilableTokens,
    'used_tokens': usedTokens,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Wallet].
  factory Wallet.fromJson(String data) {
    return Wallet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Wallet] to a JSON string.
  String toJson() => json.encode(toMap());

  Wallet copyWith({
    int? id,
    int? userId,
    String? userType,
    int? avilableTokens,
    int? usedTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      avilableTokens: avilableTokens ?? this.avilableTokens,
      usedTokens: usedTokens ?? this.usedTokens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      userType,
      avilableTokens,
      usedTokens,
      createdAt,
      updatedAt,
    ];
  }
}

import 'dart:convert';

import 'package:equatable/equatable.dart';

class Package extends Equatable {
  final int? id;
  final String? uuid;
  final String? title;
  final String? slug;
  final dynamic description;
  final String? price;
  final dynamic discountPrice;
  final String? tax;
  final String? packageType;
  final dynamic recurringInterval;
  final dynamic validityDays;
  final int? availableTokens;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Package({
    this.id,
    this.uuid,
    this.title,
    this.slug,
    this.description,
    this.price,
    this.discountPrice,
    this.tax,
    this.packageType,
    this.recurringInterval,
    this.validityDays,
    this.availableTokens,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromMap(Map<String, dynamic> data) => Package(
    id: data['id'] as int?,
    uuid: data['uuid'] as String?,
    title: data['title'] as String?,
    slug: data['slug'] as String?,
    description: data['description'] as dynamic,
    price: data['price'] as String?,
    discountPrice: data['discount_price'] as dynamic,
    tax: data['tax'] as String?,
    packageType: data['package_type'] as String?,
    recurringInterval: data['recurring_interval'] as dynamic,
    validityDays: data['validity_days'] as dynamic,
    availableTokens: data['available_tokens'] as int?,
    status: data['status'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'uuid': uuid,
    'title': title,
    'slug': slug,
    'description': description,
    'price': price,
    'discount_price': discountPrice,
    'tax': tax,
    'package_type': packageType,
    'recurring_interval': recurringInterval,
    'validity_days': validityDays,
    'available_tokens': availableTokens,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Package].
  factory Package.fromJson(String data) {
    return Package.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Package] to a JSON string.
  String toJson() => json.encode(toMap());

  Package copyWith({
    int? id,
    String? uuid,
    String? title,
    String? slug,
    dynamic description,
    String? price,
    dynamic discountPrice,
    String? tax,
    String? packageType,
    dynamic recurringInterval,
    dynamic validityDays,
    int? availableTokens,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Package(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      tax: tax ?? this.tax,
      packageType: packageType ?? this.packageType,
      recurringInterval: recurringInterval ?? this.recurringInterval,
      validityDays: validityDays ?? this.validityDays,
      availableTokens: availableTokens ?? this.availableTokens,
      status: status ?? this.status,
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
      uuid,
      title,
      slug,
      description,
      price,
      discountPrice,
      tax,
      packageType,
      recurringInterval,
      validityDays,
      availableTokens,
      status,
      createdAt,
      updatedAt,
    ];
  }
}

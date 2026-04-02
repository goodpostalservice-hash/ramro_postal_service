import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? uuid;
  final String? firstName;
  final dynamic lastName;
  final dynamic image;
  final dynamic email;
  final dynamic emailVerifiedAt;
  final String? countryCode;
  final String? phone;
  final int? isPhoneVerified;
  final String? currentLatitude;
  final String? currentLongitude;
  final String? currentCoordinates;
  final String? lastCoordinates;
  final String? lastLatitude;
  final String? lastLongitude;
  final String? ipAddress;
  final String? lastLoginIp;
  final String? lastLoginAt;
  final String? userType;
  final int? isOnline;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.uuid,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.emailVerifiedAt,
    this.countryCode,
    this.phone,
    this.isPhoneVerified,
    this.currentLatitude,
    this.currentLongitude,
    this.currentCoordinates,
    this.lastCoordinates,
    this.lastLatitude,
    this.lastLongitude,
    this.ipAddress,
    this.lastLoginIp,
    this.lastLoginAt,
    this.userType,
    this.isOnline,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
    id: data['id'] as int?,
    uuid: data['uuid'] as String?,
    firstName: data['first_name'] as String?,
    lastName: data['last_name'] as dynamic,
    image: data['image'] as dynamic,
    email: data['email'] as dynamic,
    emailVerifiedAt: data['email_verified_at'] as dynamic,
    countryCode: data['country_code'] as String?,
    phone: data['phone'] as String?,
    isPhoneVerified: data['isPhoneVerified'] as int?,
    currentLatitude: data['current_latitude'] as String?,
    currentLongitude: data['current_longitude'] as String?,
    currentCoordinates: data['current_coordinates'] as String?,
    lastCoordinates: data['last_coordinates'] as String?,
    lastLatitude: data['last_latitude'] as String?,
    lastLongitude: data['last_longitude'] as String?,
    ipAddress: data['ip_address'] as String?,
    lastLoginIp: data['last_login_ip'] as String?,
    lastLoginAt: data['last_login_at'] as String?,
    userType: data['user_type'] as String?,
    isOnline: data['is_online'] as int?,
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
    'first_name': firstName,
    'last_name': lastName,
    'image': image,
    'email': email,
    'email_verified_at': emailVerifiedAt,
    'country_code': countryCode,
    'phone': phone,
    'isPhoneVerified': isPhoneVerified,
    'current_latitude': currentLatitude,
    'current_longitude': currentLongitude,
    'current_coordinates': currentCoordinates,
    'last_coordinates': lastCoordinates,
    'last_latitude': lastLatitude,
    'last_longitude': lastLongitude,
    'ip_address': ipAddress,
    'last_login_ip': lastLoginIp,
    'last_login_at': lastLoginAt,
    'user_type': userType,
    'is_online': isOnline,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({
    int? id,
    String? uuid,
    String? firstName,
    dynamic lastName,
    dynamic image,
    dynamic email,
    dynamic emailVerifiedAt,
    String? countryCode,
    String? phone,
    int? isPhoneVerified,
    String? currentLatitude,
    String? currentLongitude,
    String? currentCoordinates,
    String? lastCoordinates,
    String? lastLatitude,
    String? lastLongitude,
    String? ipAddress,
    String? lastLoginIp,
    String? lastLoginAt,
    String? userType,
    int? isOnline,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      currentCoordinates: currentCoordinates ?? this.currentCoordinates,
      lastCoordinates: lastCoordinates ?? this.lastCoordinates,
      lastLatitude: lastLatitude ?? this.lastLatitude,
      lastLongitude: lastLongitude ?? this.lastLongitude,
      ipAddress: ipAddress ?? this.ipAddress,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      userType: userType ?? this.userType,
      isOnline: isOnline ?? this.isOnline,
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
      firstName,
      lastName,
      image,
      email,
      emailVerifiedAt,
      countryCode,
      phone,
      isPhoneVerified,
      currentLatitude,
      currentLongitude,
      currentCoordinates,
      lastCoordinates,
      lastLatitude,
      lastLongitude,
      ipAddress,
      lastLoginIp,
      lastLoginAt,
      userType,
      isOnline,
      status,
      createdAt,
      updatedAt,
    ];
  }
}

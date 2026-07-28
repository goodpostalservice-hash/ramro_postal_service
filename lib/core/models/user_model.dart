import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserData {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final String? phone;
  @HiveField(3)
  final String? userType;

  UserData({this.name, this.email, this.phone, this.userType});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      userType: json['userType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'userType': userType};
  }
}
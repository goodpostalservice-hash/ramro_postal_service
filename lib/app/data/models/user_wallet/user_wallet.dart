import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'wallet.dart';

class UserWallet extends Equatable {
  final bool? success;
  final Wallet? wallet;

  const UserWallet({this.success, this.wallet});

  factory UserWallet.fromMap(Map<String, dynamic> data) => UserWallet(
    success: data['success'] as bool?,
    wallet: data['wallet'] == null
        ? null
        : Wallet.fromMap(data['wallet'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'success': success,
    'wallet': wallet?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserWallet].
  factory UserWallet.fromJson(String data) {
    return UserWallet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserWallet] to a JSON string.
  String toJson() => json.encode(toMap());

  UserWallet copyWith({bool? success, Wallet? wallet}) {
    return UserWallet(
      success: success ?? this.success,
      wallet: wallet ?? this.wallet,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success, wallet];
}

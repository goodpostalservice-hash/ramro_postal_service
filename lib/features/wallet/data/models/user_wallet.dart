class UserWallet {
  bool? success;
  Wallet? wallet;

  UserWallet({this.success, this.wallet});

  UserWallet.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
  }
}

class Wallet {
  int? id;
  int? userId;
  String? userType;
  int? avilableTokens;
  int? usedTokens;
  String? createdAt;
  String? updatedAt;

  Wallet({
    this.id,
    this.userId,
    this.userType,
    this.avilableTokens,
    this.usedTokens,
    this.createdAt,
    this.updatedAt,
  });

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    avilableTokens = json['avilable_tokens'];
    usedTokens = json['used_tokens'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

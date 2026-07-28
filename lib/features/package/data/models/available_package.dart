class AvailablePackageModel {
  int? id;
  String? uuid;
  String? title;
  String? slug;
  Null description;
  String? price;
  Null discountPrice;
  String? tax;
  String? packageType;
  Null recurringInterval;
  Null validityDays;
  int? availableTokens;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? hasSubscribed;

  AvailablePackageModel({
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
    this.hasSubscribed,
  });

  AvailablePackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    price = json['price'];
    discountPrice = json['discount_price'];
    tax = json['tax'];
    packageType = json['package_type'];
    recurringInterval = json['recurring_interval'];
    validityDays = json['validity_days'];
    availableTokens = json['available_tokens'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hasSubscribed = json['has_subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['tax'] = tax;
    data['package_type'] = packageType;
    data['recurring_interval'] = recurringInterval;
    data['validity_days'] = validityDays;
    data['available_tokens'] = availableTokens;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['has_subscribed'] = hasSubscribed;
    return data;
  }
}

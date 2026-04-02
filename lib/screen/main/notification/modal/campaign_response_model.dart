class CampaignResponseModel {
  int? id;
  String? title;
  String? slug;
  String? featureImage;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? url;

  CampaignResponseModel({
    this.id,
    this.title,
    this.slug,
    this.featureImage,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  CampaignResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    featureImage = json['feature_image'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['feature_image'] = featureImage;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    return data;
  }
}

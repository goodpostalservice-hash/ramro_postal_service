class MyNotificationResponseModel {
  String? title;
  String? image;
  String? body;
  String? id;
  String? createdAt;

  MyNotificationResponseModel({
    this.title,
    this.image,
    this.body,
    this.id,
    this.createdAt,
  });

  MyNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    body = json['body'];
    id = json['id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['body'] = body;
    data['id'] = id;
    data['created_at'] = createdAt;
    return data;
  }
}

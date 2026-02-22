class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message({required this.text, required this.date, required this.isSentByMe});
}

class Chat {
  String? message;
  String? sender;
  String? timestamp;
  int? pickupId;
  String? username;

  Chat(
      {this.message,
      this.sender,
      this.timestamp,
      this.pickupId,
      this.username});

  Chat.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sender = json['sender'];
    timestamp = json['timestamp'];
    pickupId = json['pickup_id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['sender'] = sender;
    data['timestamp'] = timestamp;
    data['pickup_id'] = pickupId;
    data['username'] = username;
    return data;
  }
}

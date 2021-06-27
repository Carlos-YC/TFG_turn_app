import 'package:meta/meta.dart';
import 'dart:convert';

class NotificationSendRequest {
  NotificationSendRequest({
    @required this.token,
    @required this.title,
    @required this.body,
  });

  final String token;
  final String title;
  final String body;

  factory NotificationSendRequest.fromJson(String str) =>
      NotificationSendRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationSendRequest.fromMap(Map<String, dynamic> json) => NotificationSendRequest(
        token: json["token"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "title": title,
        "body": body,
      };
}

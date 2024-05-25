import 'package:cloud_firestore/cloud_firestore.dart';

class BellNotification {
  final String name;
  final String profilePic;
  final String content;
  final String postImage;
  final Timestamp time;

  BellNotification({
    required this.name, 
    required this.profilePic, 
    required this.content,
    required this.postImage, 
    required this.time
  });

  factory BellNotification.fromJson(Map<String, dynamic> json) {
    return BellNotification(
      name: json['name'],
      profilePic: json['profilePic'],
      content: json['content'],
      postImage: json['postImage'],
      time: json['time'],
    );
  }

  toJson() {}
}
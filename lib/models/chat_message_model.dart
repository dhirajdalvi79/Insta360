import 'package:cloud_firestore/cloud_firestore.dart';

/// Defines model for chat message.
class ChatMessageModel {
  Timestamp posted;
  String message;
  String fromUserId;
  String toUserId;
  String messageId;

  ChatMessageModel(
      {required this.fromUserId,
      required this.toUserId,
      required this.posted,
      required this.message,
      required this.messageId});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
        fromUserId: json['from_user_id'],
        toUserId: json['to_user_id'],
        posted: json['posted'],
        message: json['message'],
        messageId: json['message_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      "from_user_id": fromUserId,
      "to_user_id": toUserId,
      "posted": posted,
      "message": message,
      'message_id': messageId,
    };
  }
}

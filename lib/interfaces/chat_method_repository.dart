import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta360/firebase_backend/chat_methods.dart';
import 'package:insta360/models/chat_message_model.dart';

/// Abstract class which is used to implement chat methods.
abstract class ChatMethodRepository {
  Future<String> checkChatIfExistsAndCreatesNew({required String toUserId});

  Future<String> postMessage(
      {required String getToUserId, required String textMessage});

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats();

  Stream<List<ChatMessageModel>> getChatMessages({required String userId});

  factory ChatMethodRepository() => ChatMethods();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta360/interfaces/chat_method_repository.dart';
import 'package:insta360/models/chat_message_model.dart';

/// [ChatMethods] implements from [ChatMethodRepository].
/// This class includes the methods that handles chat events in the app.
/// The database used ia firebase's firestore NoSQL database.
/// Structure of chat database is followed -
/// users (Collection) -> Each user with ID (Document) -> chats (Collection) -> Each chat document having messages sharing with
/// other user (Documents) -> messages (Collection) -> all messages stored as document (Document).
class ChatMethods implements ChatMethodRepository {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /// Checks if chat exist between two user, if it doesn't exists, creates a new one.
  @override
  Future<String> checkChatIfExistsAndCreatesNew(
      {required String toUserId}) async {
    String result = 'Error';
    try {
      // Gets reference of chat collection app user (first user).
      final fromUserChatRef = firestoreInstance
          .collection('users')
          .doc(authInstance.currentUser!.uid)
          .collection('chats');
      // Gets reference of chat collection of other user (second user).
      final toUserChatRef = firestoreInstance
          .collection('users')
          .doc(toUserId)
          .collection('chats');
      // Gets the query snapshot of app user's chat collection with other user.
      final fromUserExist =
          await fromUserChatRef.where('with', isEqualTo: toUserId).get();
      // Gets the query snapshot of other user's chat collection with app user.
      final toUserExist = await toUserChatRef
          .where('with', isEqualTo: authInstance.currentUser!.uid)
          .get();
      // If the size of snapshot is 0 i.e. if the chat doesn't exist, it will create a new one.
      if (fromUserExist.size == 0 && toUserExist.size == 0) {
        await fromUserChatRef.doc(toUserId).set({
          'with': toUserId,
          'latest_msg': Timestamp.now(),
        });
        await toUserChatRef.doc(authInstance.currentUser!.uid).set({
          'with': authInstance.currentUser!.uid,
          'latest_msg': Timestamp.now(),
        });
      }
      result = 'Success';
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Method to post a chat message to other user.
  @override
  Future<String> postMessage(
      {required String getToUserId, required String textMessage}) async {
    String result = 'Error';
    try {
      // Gets the confirmation from checkChatIfExistsAndCreatesNew method that the chat exits between two users.
      String result =
          await checkChatIfExistsAndCreatesNew(toUserId: getToUserId);
      if (result == 'Success') {
        // If success,
        // Gets chat document reference of app user with other user.
        final fromUserChatRef = await firestoreInstance
            .collection('users')
            .doc(authInstance.currentUser!.uid)
            .collection('chats')
            .where('with', isEqualTo: getToUserId)
            .get();
        // Gets chat document reference of other user with app user.
        final toUserChatRef = await firestoreInstance
            .collection('users')
            .doc(getToUserId)
            .collection('chats')
            .where('with', isEqualTo: authInstance.currentUser!.uid)
            .get();
        // Gets ID of chat document reference which will be only one for app with other user.
        String fromUserChatId = fromUserChatRef.docs.first.id;
        // Vice versa
        String toUserChatId = toUserChatRef.docs.first.id;
        // Setting the time when message being posted.
        final Timestamp time = Timestamp.now();
        // Gets messages collection reference of app user.
        final fromUserChat = firestoreInstance
            .collection('users')
            .doc(authInstance.currentUser!.uid)
            .collection('chats')
            .doc(fromUserChatId)
            .collection('messages')
            .doc();
        // Setting object from Chat message model.
        final ChatMessageModel fromUserObj = ChatMessageModel(
            fromUserId: authInstance.currentUser!.uid,
            toUserId: getToUserId,
            posted: time,
            message: textMessage,
            messageId: fromUserChat.id);
        // Gets messages collection reference of other user.
        final toUserChat = firestoreInstance
            .collection('users')
            .doc(getToUserId)
            .collection('chats')
            .doc(toUserChatId)
            .collection('messages')
            .doc();
        // Setting object from Chat message model.
        final ChatMessageModel toUserObj = ChatMessageModel(
            fromUserId: authInstance.currentUser!.uid,
            toUserId: getToUserId,
            posted: time,
            message: textMessage,
            messageId: toUserChat.id);
        // Add new message with ID to messages collection in both users' database.
        await fromUserChat.set(fromUserObj.toJson());
        await toUserChat.set(toUserObj.toJson());
        // Time is updated with time of latest message being posted.
        fromUserChat.update({'latest_msg': time});
        toUserChat.update({'latest_msg': time});
        result = 'Success';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Returns stream of all chats present in database.
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    return firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .collection('chats')
        .orderBy('latest_msg', descending: false)
        .snapshots();
  }

  /// Returns stream of all chat messages of app user with other user.
  @override
  Stream<List<ChatMessageModel>> getChatMessages({required String userId}) {
    // Checks if the user id from argument is not of app user, if the user id is of other user then it checks if the chat exist
    // and creates a new one if chat doesn't exist.
    if (userId != authInstance.currentUser!.uid) {
      checkChatIfExistsAndCreatesNew(toUserId: userId);
    }
    return firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('posted', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ChatMessageModel.fromJson(document.data()))
            .toList());
  }
}

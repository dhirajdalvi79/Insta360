import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/models/comments_and_likes.dart';
import 'package:insta360/resources/utilities/constants.dart';

/// [UserInteractionsMethod] implements from [UserInteractionsMethodRepository].
/// Handles all user interaction in app.
class UserInteractionsMethod implements UserInteractionsMethodRepository {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /// Send follow request to the other user.
  @override
  Future<String> follow({required String receiverFollowId}) async {
    String result = 'Error';
    try {
      // Gets other user id.
      var receiverFollowRef =
          firestoreInstance.collection('users').doc(receiverFollowId);
      // Gets other user's follow request collection reference.
      receiverFollowRef = receiverFollowRef.collection('follow_requests').doc();
      // Adds the follow request to the collection.
      receiverFollowRef.set({
        'from_user': authInstance.currentUser!.uid,
        'posted': Timestamp.now(),
        'follow_request_id': receiverFollowRef.id,
      });
      result = 'Success';
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Accepts the received follow request from other user.
  @override
  Future<String> acceptRequest({required String getUserId}) async {
    String result = 'Error';
    // Gets follow request collection reference.
    final followRequestUserRef = firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .collection('follow_requests')
        .where('from_user', isEqualTo: getUserId);
    try {
      final getSize = await followRequestUserRef.get();
      // Checks if follow request from user (from argument) is present.
      if (getSize.size == 1) {
        // If present, then gets the app user's followers collection reference.
        final userRef = firestoreInstance
            .collection('users')
            .doc(authInstance.currentUser!.uid)
            .collection('followers')
            .doc();
        // Adds the other user to app user's followers collection.
        userRef.set({'user_id': getUserId, 'follower_doc_id': userRef.id});
        // Similarly, gets the other user's following collection reference.
        final requestUserRef = firestoreInstance
            .collection('users')
            .doc(getUserId)
            .collection('following')
            .doc();
        // Adds the app user to other user's following collection.
        requestUserRef.set({
          'user_id': authInstance.currentUser!.uid,
          'following_doc_id': requestUserRef.id
        });
        // Finally, gets the id from existing request in follow request collection.
        final id = await followRequestUserRef.get();
        // Deletes the pending request.
        await firestoreInstance
            .collection('users')
            .doc(authInstance.currentUser!.uid)
            .collection('follow_requests')
            .doc(id.docs.first.id)
            .delete();
        result = 'Success';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Declines the received follow request from other user.
  @override
  Future<String> declineRequest({required String getUserId}) async {
    String result = 'Error';
    try {
      // Gets follow request collection reference.
      final followRequestUserRef = firestoreInstance
          .collection('users')
          .doc(authInstance.currentUser!.uid)
          .collection('follow_requests')
          .where('from_user', isEqualTo: getUserId);
      final getSize = await followRequestUserRef.get();
      // Checks if follow request from user (from argument) is present.
      if (getSize.size == 1) {
        // If present, gets its id.
        final id = await followRequestUserRef.get();
        // And deletes the request using id.
        await firestoreInstance
            .collection('users')
            .doc(authInstance.currentUser!.uid)
            .collection('follow_requests')
            .doc(id.docs.first.id)
            .delete();
        result = 'Success';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Checks the follow status of other user with respect to app user and
  /// returns follow state
  @override
  Future<FollowStatus> checkFollow({required String getUserId}) async {
    // Sets follow state to not in any list.
    FollowStatus followStatus = FollowStatus.notInAnyList;
    // Gets other user's followers reference.
    final userIdRefFollowers = firestoreInstance
        .collection('users')
        .doc(getUserId)
        .collection('followers')
        .where('user_id', isEqualTo: authInstance.currentUser!.uid);
    final getSizeFromFollowers = await userIdRefFollowers.get();
    // Checks if app user exists in other user's followers collection.
    if (getSizeFromFollowers.size == 1) {
      // If exists, then sets the follow status to in followers list.
      followStatus = FollowStatus.inFollowersList;
    } else {
      // If isn't exists then checks in other user's follow request collection.
      // Gets other user's follow request collection reference.
      final userIdRefFollowRequest = firestoreInstance
          .collection('users')
          .doc(getUserId)
          .collection('follow_requests')
          .where('from_user', isEqualTo: authInstance.currentUser!.uid);
      final getSizeFromFollowRequest = await userIdRefFollowRequest.get();
      // Checks if app user exists in other user's follow request collection.
      if (getSizeFromFollowRequest.size == 1) {
        // If exists, then sets the follow status to in follow request list.
        followStatus = FollowStatus.inFollowRequestList;
        // If isn't, then the follow status will be of default, not in any list.
      }
    }
    return followStatus;
  }

  /// Checks if app user likes the user's post and returns stream of it.
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> checkLike(
      {required String getUserId, required String getPostId}) {
    return firestoreInstance
        .collection('users')
        .doc(getUserId)
        .collection('posts')
        .doc(getPostId)
        .collection('likes')
        .where('user_id', isEqualTo: authInstance.currentUser!.uid)
        .snapshots();
  }

  /// Returns collection of user's post's likes for getting like count.
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> checkLikeCount(
      {required String getUserId, required String getPostId}) {
    return firestoreInstance
        .collection('users')
        .doc(getUserId)
        .collection('posts')
        .doc(getPostId)
        .collection('likes')
        .snapshots();
  }

  /// Returns stream of user's post's all comments.
  @override
  Stream<List<Comments>> getComments(
      {required String getUserId, required String getPostId}) {
    return firestoreInstance
        .collection('users')
        .doc(getUserId)
        .collection('posts')
        .doc(getPostId)
        .collection('comments')
        .orderBy('posted', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => Comments.fromJson(document.data()))
            .toList());
  }

  /// Post comment of app user to the post of other user.
  @override
  Future<String> postComment(
      {required String comment,
      required String getUserId,
      required String getPostId}) async {
    String result = 'Error';
    try {
      // Checks if comment argument is not empty, if its empty then comment will not be posted as empty string.
      if (comment.isNotEmpty) {
        // Gets other user's post's comments collection reference.
        final postRef = firestoreInstance
            .collection('users')
            .doc(getUserId)
            .collection('posts')
            .doc(getPostId)
            .collection('comments')
            .doc();
        // Post comment of app user to the post of other user.
        postRef.set({
          "comment": comment,
          "comment_id": postRef.id,
          "posted": Timestamp.now(),
          "user_id": authInstance.currentUser!.uid,
        });
        result = 'Success';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Delete selected comment of app user.
  @override
  Future<String> deleteComment(
      {required String getCommentId,
      required String getUserId,
      required String getPostId}) async {
    String result = 'Error';
    try {
      // Gets comments id from arguments and with reference, deletes it.
      await firestoreInstance
          .collection('users')
          .doc(getUserId)
          .collection('posts')
          .doc(getPostId)
          .collection('comments')
          .doc(getCommentId)
          .delete();
      result = 'Success';
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Handles post likes and dislikes events.
  @override
  void postLikeDislike(
      {required String getUserId, required String getPostId}) async {
    // Gets user's post's likes reference.
    final postRef = firestoreInstance
        .collection('users')
        .doc(getUserId)
        .collection('posts')
        .doc(getPostId)
        .collection('likes')
        .doc();
    // Gets user's post's likes reference for checking app user's has liked the post.
    final checkLike = firestoreInstance
        .collection('users')
        .doc(getUserId)
        .collection('posts')
        .doc(getPostId)
        .collection('likes')
        .where('user_id', isEqualTo: authInstance.currentUser!.uid);
    final getSize = await checkLike.get();
    // Checks if app user has liked the post or not.
    if (getSize.size == 0) {
      // If app user has not liked the post then like document from app user is added to collection,
      // giving post a like.
      postRef.set({
        'user_id': authInstance.currentUser!.uid,
        'like_id': postRef.id,
      });
    } else {
      // If app user has already liked a post, the on event, like document of app user will
      // be removed from likes collection.
      final getRef = await firestoreInstance
          .collection('users')
          .doc(getUserId)
          .collection('posts')
          .doc(getPostId)
          .collection('likes')
          .where('user_id', isEqualTo: authInstance.currentUser!.uid)
          .get();
      // Initialize map to get existing like document data of app user.
      Map<String, dynamic> getData = {};
      for (var doc in getRef.docs) {
        getData = doc.data();
      }
      // We are not using postRef.id because every time we call function, postRef.id will have new unique id value.
      // Remove the like of app user from other user's post's likes.
      await firestoreInstance
          .collection('users')
          .doc(getUserId)
          .collection('posts')
          .doc(getPostId)
          .collection('likes')
          .doc(getData['like_id'])
          .delete();
    }
  }

  /// Returns a stream of user's follow request collection.
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> checkFollowRequest() {
    return firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .collection('follow_requests')
        .snapshots();
  }
}

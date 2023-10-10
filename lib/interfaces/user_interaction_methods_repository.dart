import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta360/firebase_backend/user_interactions_methods.dart';
import 'package:insta360/models/comments_and_likes.dart';
import 'package:insta360/resources/utilities/constants.dart';

/// Abstract class which is used to implement user interaction methods.
abstract class UserInteractionsMethodRepository {
  Future<String> follow({required String receiverFollowId});

  Future<FollowStatus> checkFollow({required String getUserId});

  Future<String> acceptRequest({required String getUserId});

  Future<String> declineRequest({required String getUserId});

  Stream<QuerySnapshot<Map<String, dynamic>>> checkLike(
      {required String getUserId, required String getPostId});

  Stream<QuerySnapshot<Map<String, dynamic>>> checkLikeCount(
      {required String getUserId, required String getPostId});

  Stream<List<Comments>> getComments(
      {required String getUserId, required String getPostId});

  Future<String> postComment(
      {required String comment,
      required String getUserId,
      required String getPostId});

  Future<String> deleteComment(
      {required String getCommentId,
      required String getUserId,
      required String getPostId});

  Stream<QuerySnapshot<Map<String, dynamic>>> checkFollowRequest();

  void postLikeDislike({required String getUserId, required String getPostId});

  factory UserInteractionsMethodRepository() => UserInteractionsMethod();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta360/interfaces/feeds_repository.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/models/user.dart';

/// [FeedsMethods] implements from [FeedRepository].
/// This handles the feeds on the user's home screen.
class FeedsMethods implements FeedRepository {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /// Returns list of all posts from followed users and user's own post, sorted with respect to time posted.
  @override
  Future<List<Posts>> getFeeds() async {
    final User currentUser = authInstance.currentUser!;
    // Setting empty list for feeds.
    List<Posts> feedList = [];
    // Getting collection named following's reference.
    final userSnaps = await firestoreInstance
        .collection("users")
        .doc(currentUser.uid)
        .collection("following")
        .get();
    // Loops through all documents of users which app user follows.
    for (var userSnap in userSnaps.docs) {
      var postSnaps = await firestoreInstance
          .collection("users")
          .doc(userSnap["user_id"])
          .collection("posts")
          .get();

      var user = await firestoreInstance
          .collection("users")
          .doc(userSnap["user_id"])
          .get();
      // Loops through all posts of individual user, creates post object from post model and adds them to feedList list.
      for (var postSnap in postSnaps.docs) {
        // Getting each posts likes for like count.
        var eachPostLikes = await firestoreInstance
            .collection("users")
            .doc(userSnap["user_id"])
            .collection("posts")
            .doc(postSnap["post_id"])
            .collection("likes")
            .get();
        // Getting each posts comments for number of comments.
        var eachPostComments = await firestoreInstance
            .collection('users')
            .doc(userSnap["user_id"])
            .collection("posts")
            .doc(postSnap["post_id"])
            .collection("comments")
            .get();
        // Making object from post model.
        Posts obj = Posts(
            userName: user.data()?["username"],
            userProfilePic: user.data()?["profile_pic"],
            userId: user.data()?["id"],
            postId: postSnap["post_id"],
            post: postSnap["post"],
            caption: postSnap["caption"],
            type: postSnap["type"],
            posted: postSnap["posted"],
            likesCount: eachPostLikes.size,
            commentsCount: eachPostComments.size);
        // Adding each posts to feedList List.
        feedList.add(obj);
      }
    }
    // Getting app user's own posts and adding to the list.
    final obj = UserDataMethodsRepository();
    final userPostList = await obj.getUserPosts(userId: currentUser.uid);
    if (userPostList.isNotEmpty) {
      feedList.addAll(userPostList);
    }
    // Finally sorting all added post with respect to time posted.
    feedList.sort();

    return feedList;
  }

  /// Returns all users present in database.
  @override
  Future<List<UserModel>> getAllUsers() async {
    final userSnaps = await firestoreInstance.collection("users").get();
    List<UserModel> userList = [];
    for (var userSnap in userSnaps.docs) {
      UserModel obj = UserModel(
          id: userSnap["id"],
          userName: userSnap["username"],
          firstName: userSnap["first_name"],
          lastName: userSnap["last_name"],
          email: userSnap["email"],
          created: userSnap["created"],
          profilePic: userSnap["profile_pic"],
          dateOfBirth: userSnap["date_of_birth"],
          accountPrivacy: userSnap["account_privacy"]);
      userList.add(obj);
    }
    return userList;
  }
}

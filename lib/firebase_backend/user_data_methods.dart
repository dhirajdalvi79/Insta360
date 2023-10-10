import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta360/bussiness_logic/core/io_methods.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/models/user.dart';

/// [UserDataMethods] implements from [UserDataMethodsRepository].
/// This handles all data related to app user.
class UserDataMethods implements UserDataMethodsRepository {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /// Returns all data of app user.
  @override
  Future<UserModel> getUserData({required String userId}) async {
    // Gets app user document reference.
    final userRef = firestoreInstance.collection("users").doc(userId);
    // Gets user's post collection reference.
    final QuerySnapshot<Map<String, dynamic>> postRef =
        await userRef.collection("posts").get();
    // Gets total number of posts of user.
    final numberOfPost = postRef.size;
    // Gets collection named followers' reference.
    final QuerySnapshot<Map<String, dynamic>> followersRef =
        await userRef.collection("followers").get();
    // Gets total number of followers.
    final int numberOfFollowers = followersRef.size;
    // Gets collection named followings' reference.
    final QuerySnapshot<Map<String, dynamic>> followingRef =
        await userRef.collection("following").get();
    // Gets total number of following.
    final int numberOfFollowing = followingRef.size;
    // Gets document snapshot of user data.
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await userRef.get();
    // Gets document snapshot as Map.
    Map<String, dynamic> user = documentSnapshot.data() as Map<String, dynamic>;
    // Sets others data to the variable user.
    user["post_count"] = numberOfPost;
    user["followers_count"] = numberOfFollowers;
    user["following_count"] = numberOfFollowing;
    // Returning the object of user.
    return UserModel.fromJson(user);
  }

  /// Returns stream of user data.
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    return firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .snapshots();
  }

  /// Returns list of all user present in user's followers list.
  @override
  Future<List<UserModel>> getFollowers({required String userId}) async {
    final userSnaps = await firestoreInstance
        .collection("users")
        .doc(userId)
        .collection('followers')
        .get();
    List<UserModel> userList = [];
    for (var userSnap in userSnaps.docs) {
      String id = userSnap['user_id'];
      UserModel user = await getUserData(userId: id);
      userList.add(user);
    }
    return userList;
  }

  /// Returns list of all user present in user's following list.
  @override
  Future<List<UserModel>> getFollowing({required String userId}) async {
    final userSnaps = await firestoreInstance
        .collection("users")
        .doc(userId)
        .collection('following')
        .get();
    List<UserModel> userList = [];
    for (var userSnap in userSnaps.docs) {
      String id = userSnap['user_id'];
      UserModel user = await getUserData(userId: id);
      userList.add(user);
    }
    return userList;
  }

  /// Update user data, the type of data and its value are determined from passed arguments.
  @override
  Future<String> updateUserData(
      {required String userProperty, required String userPropertyValue}) async {
    String result = 'Error';
    try {
      final userRef = firestoreInstance
          .collection("users")
          .doc(authInstance.currentUser!.uid);
      userRef.update({userProperty: userPropertyValue});
      result = 'Success';
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Update profile image of app user.
  @override
  Future<String> updateProfilePic(ImageSource source) async {
    String result = 'Error';
    final ioObj = UserIoMethods();
    // Gets image from image picker.
    XFile? image = await ioObj.pickImage(source);
    if (image != null) {
      // Gets path from firebase storage.
      final userRef = storageInstance
          .ref()
          .child(authInstance.currentUser!.uid)
          .child('profile_image')
          .child('user_profile_image');
      try {
        // Try deleting the previous profile image, if it exists.
        await userRef.delete();
      } finally {
        // Finally set the new profile image selected by user.
        final obj = UserIoMethods();
        CroppedFile? croppedImage =
            await obj.getCroppedImage(imagePath: image.path);
        Uint8List? imageBytes = await croppedImage?.readAsBytes();
        Reference ref = storageInstance
            .ref()
            .child(authInstance.currentUser!.uid)
            .child('profile_image')
            .child('user_profile_image');
        // Sets the task for uploading file.
        UploadTask uploadTask = ref.putData(imageBytes!);
        TaskSnapshot snapshot = await uploadTask;
        // Gets download url of uploaded file.
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // Updates the profile image of user.
        final user = firestoreInstance
            .collection("users")
            .doc(authInstance.currentUser!.uid);
        user.update({'profile_pic': downloadUrl});
        result = 'Success';
      }
    }
    return result;
  }

  /// Returns list of all posts of app user.
  @override
  Future<List<Posts>> getUserPosts({required String userId}) async {
    // Gets user's post collection reference.
    final snaps = await firestoreInstance
        .collection("users")
        .doc(userId)
        .collection("posts")
        .get();
    // Gets app user reference.
    final user = await firestoreInstance.collection("users").doc(userId).get();
    // Initialize empty list of posts.
    List<Posts> postLists = [];
    // Loops through all post of app user.
    for (var snap in snaps.docs) {
      // Gets each post likes for like count.
      var eachPostLikes = await firestoreInstance
          .collection('users')
          .doc(userId)
          .collection("posts")
          .doc(snap["post_id"])
          .collection("likes")
          .get();
      // Gets each post comments for number of comment.
      var eachPostComments = await firestoreInstance
          .collection('users')
          .doc(userId)
          .collection("posts")
          .doc(snap["post_id"])
          .collection("comments")
          .get();
      // Making Post object.
      Posts obj = Posts(
          userName: user.data()?["username"],
          userProfilePic: user.data()?["profile_pic"],
          userId: user.data()?["id"],
          postId: snap["post_id"],
          post: snap["post"],
          caption: snap["caption"],
          type: snap["type"],
          posted: snap["posted"],
          likesCount: eachPostLikes.size,
          commentsCount: eachPostComments.size);
      // Add post object to post list.
      postLists.add(obj);
    }
    return postLists;
  }
}

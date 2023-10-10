import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta360/firebase_backend/user_data_methods.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/models/user.dart';

/// Abstract class which is used to implement user data methods.
abstract class UserDataMethodsRepository {
  Future<UserModel> getUserData({required String userId});

  Future<List<Posts>> getUserPosts({required String userId});

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream();

  Future<String> updateUserData(
      {required String userProperty, required String userPropertyValue});

  Future<String> updateProfilePic(ImageSource source);

  Future<List<UserModel>> getFollowers({required String userId});

  Future<List<UserModel>> getFollowing({required String userId});

  factory UserDataMethodsRepository() => UserDataMethods();
}

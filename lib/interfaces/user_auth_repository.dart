import 'package:insta360/firebase_backend/user_authentication.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Abstract class which is used to implement user authentication methods.
abstract class UserAuthenticationRepository {
  Future<String> userLogin(
      {required String getEmail, required String getPassword});

  Future<String> uploadProfilePic({required Uint8List getImage});

  Future<String> userSignUp(
      {required String getUserName,
      required String getPassword,
      required String getEmail,
      required String getFirstName,
      required String getLastName,
      required Uint8List? getProfilePic,
      required Timestamp getDateOfBirth});

  Future<void> userLogout();

  factory UserAuthenticationRepository() => UserAuthentication();
}

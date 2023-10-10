import 'package:insta360/interfaces/user_auth_repository.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';

/// [UserAuthentication] implements from [UserAuthenticationRepository].
/// This handles user's authentication with firebase.
class UserAuthentication implements UserAuthenticationRepository {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /// Uploads user's profile image to the database and returns download url of uploaded file.
  @override
  Future<String> uploadProfilePic({required Uint8List getImage}) async {
    String result = 'Error';
    try {
      // Setting the path for upload in firebase storage.
      Reference ref = storageInstance
          .ref()
          .child(authInstance.currentUser!.uid)
          .child('profile_image')
          .child('user_profile_image');
      // Sets the task for uploading file.
      UploadTask uploadTask = ref.putData(getImage);
      TaskSnapshot snapshot = await uploadTask;
      // Gets download url of uploaded file.
      String downloadUrl = await snapshot.ref.getDownloadURL();
      result = downloadUrl;
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Log in user to the firebase.
  @override
  Future<String> userLogin(
      {required String getEmail, required String getPassword}) async {
    String result = 'Error';
    try {
      await authInstance.signInWithEmailAndPassword(
          email: getEmail, password: getPassword);
      result = "Success";
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// Log out user from the firebase.
  @override
  Future<void> userLogout() async {
    await authInstance.signOut();
  }

  /// Sign up new user to the firebase and add it to the database.
  @override
  Future<String> userSignUp(
      {required String getUserName,
      required String getPassword,
      required String getEmail,
      required String getFirstName,
      required String getLastName,
      required Uint8List? getProfilePic,
      required Timestamp getDateOfBirth}) async {
    String result = 'Error';
    try {
      // Create new user with email and password.
      UserCredential userCred =
          await authInstance.createUserWithEmailAndPassword(
              email: getEmail, password: getPassword);

      String profilePicUrl = '';
      // Checks if the profilePicUrl is not null and gets the url for profile image from uploadProfilePic method.
      // If profilePicUrl is null then its value will be initial default empty string, profilePicUrl = ''.
      if (getProfilePic != null) {
        profilePicUrl = await uploadProfilePic(getImage: getProfilePic);
      }
      // Creating user object.
      UserModel userObj = UserModel(
          id: userCred.user!.uid,
          userName: getUserName,
          firstName: getFirstName,
          lastName: getLastName,
          email: getEmail,
          created: Timestamp.now(),
          profilePic: profilePicUrl,
          dateOfBirth: getDateOfBirth,
          accountPrivacy: false);
      // Saving the user to the database.
      await firestoreInstance
          .collection("users")
          .doc(userCred.user!.uid)
          .set(userObj.toJson());
      result = "Success";
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}

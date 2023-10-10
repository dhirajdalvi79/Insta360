import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:insta360/bussiness_logic/providers/progress_indicator_status.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta360/interfaces/post_method_repository.dart';

/// [PostMethods] implements from [PostMethodsRepository].
class PostMethods implements PostMethodsRepository {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /// Add post to the database posted by user.
  @override
  Future<String> addPost(
      {required Uint8List post,
      required String getCaption,
      required String type,
      required BuildContext context}) async {
    String result = 'Error';
    // Gets uid for unique name for a post in database.
    const uuid = Uuid();
    final getFileName = uuid.v4();
    try {
      // Checks if the post is of type image of video from argument and sets the path in firebase storage.
      Reference ref = type == 'img'
          ? storageInstance
              .ref()
              .child(authInstance.currentUser!.uid)
              .child('posts')
              .child('images')
              .child(getFileName)
          : storageInstance
              .ref()
              .child(authInstance.currentUser!.uid)
              .child('posts')
              .child('videos')
              .child(getFileName);
      // Sets the task for uploading file.
      UploadTask uploadTask = ref.putData(post);
      // For indicator how much bytes is uploaded.
      var obj = context.read<ProgressIndicatorStatus>();
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        if (taskSnapshot.state == TaskState.running) {
          obj.getCalculatedValue(
              getValue: taskSnapshot.bytesTransferred,
              getTotalValue: taskSnapshot.totalBytes);
        } else if (taskSnapshot.state == TaskState.success) {
        } else if (taskSnapshot.state == TaskState.error) {}
      });
      TaskSnapshot snapshot = await uploadTask;
      // Gets download url of uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();
      result = downloadUrl;
      // Gets posts collection reference of user.
      final userRef = firestoreInstance
          .collection('users')
          .doc(authInstance.currentUser!.uid)
          .collection('posts')
          .doc();
      // Adds the uploaded post download url string to the database.
      userRef.set({
        'post': downloadUrl,
        'posted': Timestamp.now(),
        'post_id': userRef.id,
        'type': type == 'img' ? 'img' : 'vid',
        'caption': getCaption,
        'file_name': getFileName,
      });
      result = 'Success';
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}

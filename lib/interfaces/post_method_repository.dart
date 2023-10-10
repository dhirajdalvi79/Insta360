import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:insta360/firebase_backend/post_methods.dart';

/// Abstract class which is used to implement post methods.
abstract class PostMethodsRepository {
  Future<String> addPost(
      {required Uint8List post,
      required String getCaption,
      required String type,
      required BuildContext context});

  factory PostMethodsRepository() => PostMethods();
}

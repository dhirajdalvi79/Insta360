import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta360/bussiness_logic/core/io_methods.dart';
import 'package:video_compress/video_compress.dart';

/// Selection type for media upload
enum PostType {
  imagePost,
  videoPost,
}

/// Handles selection of post for media upload and
/// also handles state of files set for upload.
class SelectPostTypeState with ChangeNotifier {
  PostType postType = PostType.imagePost;
  XFile? post;
  Uint8List? postBytes;

  /// Select upload post to type video.
  void selectVideoPost() {
    postType = PostType.videoPost;
    notifyListeners();
  }

  /// Select upload post to type image.
  void selectImagePost() {
    postType = PostType.imagePost;
    notifyListeners();
  }

  /// Select image from source and set the state for image in [XFile] and in [Uint8List].
  void selectImage(ImageSource source) async {
    var ioObj = UserIoMethods();
    XFile? image = await ioObj.pickImage(source);
    if (image != null) {
      post = image;
      postBytes = await post?.readAsBytes();
    }
    notifyListeners();
  }

  /// Select video from source and set the state for video in [XFile] and in [Uint8List].
  void selectVideo(ImageSource source) async {
    var ioObj = UserIoMethods();
    XFile? video = await ioObj.pickVideo(source);
    if (video != null) {
      await VideoCompress.deleteAllCache();
      await VideoCompress.setLogLevel(0);
      // Video is compressed for handling large video file.
      final info = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      post = XFile(info!.path!);
      postBytes = await info.file!.readAsBytes();
    }
    notifyListeners();
  }
}

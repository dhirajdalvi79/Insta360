import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Handles input output methods from device
class UserIoMethods {
  /// Pick image from device and returns it as [XFile] by using [ImagePicker].
  Future<XFile?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return file;
    }
    return null;
  }

  /// Pick video from device and returns it as [XFile] by using [ImagePicker].
  Future<XFile?> pickVideo(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickVideo(source: source);
    if (file != null) {
      return file;
    }
    return null;
  }

  /// Take image from path as a source and returns cropped image in 1:1 ratio by using [ImageCropper].
  Future<CroppedFile?> getCroppedImage({required String imagePath}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Set Photo',
            toolbarColor: Colors.black87,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
      ],
    );
    return croppedFile;
  }
}

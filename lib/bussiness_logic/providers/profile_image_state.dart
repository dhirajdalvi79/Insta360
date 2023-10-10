import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../core/io_methods.dart';

/// Handles state of profile image selected by user.
class ProfileImageSelector with ChangeNotifier {
  String? profileImage;
  Uint8List? imageBytes;

  /// Select image from source and set the state for image in [Uint8List] and its path.
  void selectImage(ImageSource source) async {
    var ioObj = UserIoMethods();
    XFile? image = await ioObj.pickImage(source);
    if (image != null) {
      var obj = UserIoMethods();
      // Getting image cropped in 1:1 ratio for profile image.
      CroppedFile? croppedImage =
          await obj.getCroppedImage(imagePath: image.path);
      profileImage = croppedImage?.path;
      imageBytes = await croppedImage?.readAsBytes();
    }
    notifyListeners();
  }
}

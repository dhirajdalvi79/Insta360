import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Handles the like action state by getting the current like count
/// and also increment the current like count by tap event.
class LikeState with ChangeNotifier {
  Icon likeIcon = const Icon(CupertinoIcons.heart);
  int likeCount = 0;

  /// Set the initial state of icon and like count from received arguments.
  void getInitial({required Icon getIcon, required int getLikeCount}) {
    likeIcon = getIcon;
    likeCount = getLikeCount;
    notifyListeners();
  }

  /// Set the icon to [CupertinoIcons.heart_fill] and increment the current like count.
  void onTapLike() {
    likeIcon = const Icon(
      CupertinoIcons.heart_fill,
      color: Colors.red,
    );
    likeCount++;
  }
}

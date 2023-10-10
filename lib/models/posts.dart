import 'package:cloud_firestore/cloud_firestore.dart';

/// Defines model for posts.
class Posts implements Comparable<Posts> {
  String userName;
  String userProfilePic;
  String userId;
  String post;
  String type;
  String postId;
  String caption;
  Timestamp posted;
  int? likesCount;
  int? commentsCount;

  Posts({
    required this.userName,
    required this.userProfilePic,
    required this.userId,
    required this.postId,
    required this.caption,
    required this.post,
    required this.type,
    this.likesCount,
    this.commentsCount,
    required this.posted,
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
        userName: json["username"],
        userProfilePic: json["user_profile_pic"],
        userId: json["id"],
        postId: json["post_id"],
        caption: json["caption"],
        post: json["post"],
        type: json["type"],
        likesCount: json["likes"],
        commentsCount: json["comments"],
        posted: json["posted"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "post_id": postId,
      "post": post,
      "caption": caption,
      "type": type,
      "posted": posted,
    };
  }

  @override
  int compareTo(Posts other) {
    //return posted.compareTo(other.posted); for ascending
    return other.posted.compareTo(posted);
  }
}

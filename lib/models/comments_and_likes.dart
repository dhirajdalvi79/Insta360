import 'package:cloud_firestore/cloud_firestore.dart';

/// Defines model for post comment.
class Comments {
  Timestamp posted;
  String userId;
  String commentId;
  String comment;

  Comments({
    required this.commentId,
    required this.posted,
    required this.userId,
    required this.comment,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
        commentId: json["comment_id"],
        posted: json["posted"],
        userId: json["user_id"],
        comment: json["comment"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "comment_id": commentId,
      "posted": posted,
      "user_id": userId,
      "comment": comment,
    };
  }
}

/// Defines model for post likes.
class Likes {
  Timestamp posted;
  String userId;
  String likeId;

  Likes({required this.likeId, required this.posted, required this.userId});

  factory Likes.fromJson(Map<String, dynamic> json) {
    return Likes(
        likeId: json["post_id"], posted: json["post"], userId: json["type"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "post_id": likeId,
      "post": posted,
      "type": userId,
    };
  }
}

import 'dart:convert';

List<Feeds> feedsFromJson(String str) =>
    List<Feeds>.from(json.decode(str).map((x) => Feeds.fromJson(x)));

/// Defines model for feeds.
class Feeds {
  int id;
  Map<String, dynamic> user;
  String sourceUrl;
  String caption;
  String posted;
  List likes;
  List comments;

  Feeds(
      {required this.id,
      required this.user,
      required this.sourceUrl,
      required this.caption,
      required this.posted,
      required this.likes,
      required this.comments});

  factory Feeds.fromJson(Map<String, dynamic> json) {
    return Feeds(
        id: json["id"],
        user: json["user"],
        sourceUrl: json["image"],
        caption: json["caption"],
        posted: json["posted"],
        likes: json["likes"],
        comments: json["comments"]);
  }
}

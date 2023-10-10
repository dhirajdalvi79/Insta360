import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<UserModel> userFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Defines model for user.
class UserModel {
  String id;
  String userName;
  String firstName;
  String lastName;
  String email;
  Timestamp created;
  String profilePic;
  Timestamp dateOfBirth;
  bool accountPrivacy;

  //
  int? postCount;
  int? followersCount;
  int? followingCount;

  UserModel({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.created,
    required this.profilePic,
    required this.dateOfBirth,
    required this.accountPrivacy,
    //
    this.postCount,
    this.followersCount,
    this.followingCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      userName: json["username"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      created: json["created"],
      profilePic: json["profile_pic"],
      dateOfBirth: json["date_of_birth"],
      accountPrivacy: json["account_privacy"],
      //
      postCount: json["post_count"],
      followersCount: json["followers_count"],
      followingCount: json["following_count"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": userName,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "created": created,
      "profile_pic": profilePic,
      "date_of_birth": dateOfBirth,
      "account_privacy": accountPrivacy,
    };
  }
}

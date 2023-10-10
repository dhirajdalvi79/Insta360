import 'package:insta360/firebase_backend/feeds_methods.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/models/user.dart';

/// Abstract class which is used to implement feed methods.
abstract class FeedRepository {
  Future<List<Posts>> getFeeds();

  Future<List<UserModel>> getAllUsers();

  factory FeedRepository() => FeedsMethods();
}

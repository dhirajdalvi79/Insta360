import 'package:flutter/material.dart';

import 'package:insta360/interfaces/feeds_repository.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/UI/widgets/post_view.dart';

import 'package:insta360/resources/UI/widgets/user_cards.dart';

/// Display all recent feeds of users that app user follows.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize feed methods.
    final obj = FeedRepository();
    return FutureBuilder(
      // Gets all feeds.
      future: obj.getFeeds(),
      builder: (BuildContext context, AsyncSnapshot<List<Posts>?> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          // Display all feeds from index 1 not from index 0, for user card to be
          // displayed at top with horizontal scroll.
          return ListView.separated(
              itemBuilder: (BuildContext context, index) {
                int imageIndex = index - 1;
                if (index == 0) {
                  return const SizedBox(
                    height: 1,
                  );
                } else {
                  return PostView(
                    postId: data[imageIndex].postId,
                    postUserProfilePicUrl: data[imageIndex].userProfilePic,
                    postUser: data[imageIndex].userName,
                    postUserId: data[imageIndex].userId,
                    posted: data[imageIndex].posted,
                    caption: data[imageIndex].caption,
                    likes: data[imageIndex].likesCount!,
                    comments: data[imageIndex].commentsCount!,
                    post: data[imageIndex].post,
                    typeOfPost: data[imageIndex].type,
                  );
                }
              },
              separatorBuilder: (BuildContext context, index) {
                // List of all user is kept only at index 0 of separator builder.
                // This list user card with horizontal scroll.
                if (index == 0) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 182,
                        child: FutureBuilder(
                          future: obj.getAllUsers(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<UserModel>?> snapshot) {
                            if (snapshot.hasData) {
                              final userData = snapshot.data;
                              return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, index) {
                                    return UserCardVertical(
                                      key: UniqueKey(),
                                      imageUrl: userData[index].profilePic,
                                      firstName: userData[index].firstName,
                                      lastName: userData[index].lastName,
                                      userName: userData[index].userName,
                                      userId: userData[index].id,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, index) {
                                    return const SizedBox(
                                      width: 10,
                                    );
                                  },
                                  itemCount: userData!.length);
                            } else if (snapshot.hasError) {
                              return const Text('No');
                            }
                            return const Text('Loading');
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                    ],
                  );
                }
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: data!.length + 1);
        }
        return const Text('No data');
      },
    );
  }
}

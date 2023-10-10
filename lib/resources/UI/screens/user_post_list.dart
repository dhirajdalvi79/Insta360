import 'package:flutter/material.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/resources/UI/widgets/post_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Display user's post in list with position of scroll as argument.
class UserPostList extends StatefulWidget {
  const UserPostList(
      {super.key,
      required this.postType,
      this.postPosition = 0,
      required this.getUser});

  final String postType;
  final int postPosition;
  final String getUser;

  @override
  State<UserPostList> createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList> {
  late ItemScrollController myScrollController;

  @override
  void initState() {
    super.initState();
    myScrollController = ItemScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initializing user data methods.
    final obj = UserDataMethodsRepository();
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: obj.getUserPosts(userId: widget.getUser),
          builder: (BuildContext context, AsyncSnapshot<List<Posts>> snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data;
              // List view with scroll position.
              return ScrollablePositionedList.separated(
                  initialScrollIndex: widget.postPosition,
                  itemScrollController: myScrollController,
                  itemCount: userData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PostView(
                      postId: userData[index].postId,
                      postUserProfilePicUrl: userData[index].userProfilePic,
                      postUser: userData[index].userName,
                      postUserId: userData[index].userId,
                      posted: userData[index].posted,
                      caption: userData[index].caption,
                      likes: userData[index].likesCount!,
                      comments: userData[index].commentsCount!,
                      post: userData[index].post,
                      typeOfPost: userData[index].type,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

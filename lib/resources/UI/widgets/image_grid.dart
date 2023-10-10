import 'package:flutter/material.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/posts.dart';
import 'package:insta360/resources/UI/screens/user_post_list.dart';

/// Displays image post in grid in user's profile screen.
class ImageGrid extends StatelessWidget {
  const ImageGrid({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  Widget build(BuildContext context) {
    // Initializing user data methods.
    final obj = UserDataMethodsRepository();
    return FutureBuilder(
        future: obj.getUserPosts(userId: user),
        builder: (BuildContext context, AsyncSnapshot<List<Posts>> snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data;
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, index) {
                // Selecting image type from posts of user.
                if (posts![index].type == 'img') {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            // Opens user post list screen with passed index to scroll to that post in list.
                            return UserPostList(
                              postType: 'img',
                              getUser: user,
                              postPosition: index,
                            );
                          },
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Image.network(
                          posts[index].post,
                          fit: BoxFit.fill,
                          cacheWidth: 200,
                          cacheHeight: 200,
                        ),
                        const Positioned(
                            right: 7,
                            top: 5,
                            child: Icon(Icons.vrpano_outlined))
                      ],
                    ),
                  );
                }
                return const SizedBox();
              }, childCount: posts?.length),
            );
          }
          if (snapshot.hasError) {
            return SliverList(
                delegate: SliverChildListDelegate([const Text('User')]));
          }
          return SliverList(
              delegate: SliverChildListDelegate([const Text('User')]));
        });
  }
}

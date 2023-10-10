import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta360/firebase_backend/user_data_methods.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/models/comments_and_likes.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/UI/widgets/comment_card.dart';
import 'package:insta360/resources/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:panorama/panorama.dart';
import 'package:video_360/video_360.dart';

/// Displays user's post.
class PostView extends StatelessWidget {
  const PostView(
      {Key? key,
      required this.postId,
      required this.postUser,
      required this.postUserId,
      required this.postUserProfilePicUrl,
      required this.posted,
      required this.likes,
      required this.comments,
      required this.post,
      required this.caption,
      required this.typeOfPost})
      : super(key: key);

  final String postId;
  final String postUser;
  final String postUserId;
  final String postUserProfilePicUrl;
  final String post;
  final Timestamp posted;
  final int likes;
  final int comments;
  final String caption;
  final String typeOfPost;

  @override
  Widget build(BuildContext context) {
    // Initializing user interaction methods.
    final obj = UserInteractionsMethodRepository();
    // Getting screen height.
    final height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 7, bottom: 10, left: 20, right: 15),
          child: Row(
            children: [
              // Profile image of user who posted this post.
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(postUserProfilePicUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    // Opens user profile screen.
                    context.goNamed(userProfileScreen, pathParameters: {
                      "user_id": postUserId,
                    });
                  },
                  // Name of user who posted this post.
                  child: Text(postUser)),
              Expanded(child: Container()),
              const Icon(
                CupertinoIcons.ellipsis_vertical,
                size: 21,
              )
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(width: 0.3, color: Colors.white),
                  bottom: BorderSide(width: 0.3, color: Colors.white))),
          width: double.infinity,
          height: height * 0.6,
          // Using row to centralize the post view horizontally.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // Keeping height of post to be 60% of screen height.
                height: height * 0.6,
                child: AspectRatio(
                  aspectRatio: 0.6,
                  // 3D images and videos render outside the boundary of container or sized box,
                  // so for that we have clipped it.
                  child: ClipPath(
                    clipper: PostClipper(),
                    // If type of post is image, then it will render 3D image in ImagePost widget
                    // and if post type is video it will render 3D video in VideoPost widget.
                    child: typeOfPost == 'img'
                        ? ImagePost(
                            postUrl: post,
                          )
                        : VideoPost(
                            postUrl: post,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 7, bottom: 7, left: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Displays red heart icon if app user have liked the post and if
                  // app user haven't liked the post then it will display normal heart icon.
                  StreamBuilder(
                    stream:
                        obj.checkLike(getUserId: postUserId, getPostId: postId),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data?.size == 1) {
                            return GestureDetector(
                              onTap: () {
                                obj.postLikeDislike(
                                    getUserId: postUserId, getPostId: postId);
                              },
                              child: const Icon(
                                CupertinoIcons.heart_fill,
                                color: Colors.red,
                              ),
                            );
                          } else if (data?.size == 0) {
                            return GestureDetector(
                                onTap: () {
                                  obj.postLikeDislike(
                                      getUserId: postUserId, getPostId: postId);
                                },
                                child: const Icon(CupertinoIcons.heart));
                          }
                        }
                        if (snapshot.hasError) {
                          return const Icon(CupertinoIcons.heart);
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Icon(CupertinoIcons.heart);
                      }
                      return const Icon(CupertinoIcons.heart);
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  // Comment icon which being tapped on, opens all comments which are commented on this post.
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CommentsList(
                                getPostId: postId,
                                getUserId: postUserId,
                              );
                            });
                      },
                      child: const Icon(CupertinoIcons.chat_bubble)),
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(CupertinoIcons.paperplane),
                  Expanded(child: Container()),
                  const Icon(CupertinoIcons.bookmark),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Shows number of likes.
              StreamBuilder(
                stream: obj.checkLikeCount(
                    getUserId: postUserId, getPostId: postId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final likesCount = snapshot.data?.size;

                      return Text('$likesCount likes');
                    }
                    if (snapshot.hasError) {
                      return const Text('0 likes');
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('0 likes');
                  }

                  return const Text('0 likes');
                },
              ),
              const SizedBox(
                height: 5,
              ),
              // Shows caption if caption is not empty.
              if (caption.isNotEmpty)
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: postUser,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' '),
                  TextSpan(text: caption)
                ], style: const TextStyle(fontSize: 15))),
              const SizedBox(
                height: 5,
              ),
              // If number of comments is greater than 0, it shows view comments.
              if (comments > 0)
                // If number of comments is greater than 1, it show view all comments.
                if (comments > 1)
                  GestureDetector(
                      onTap: () {
                        // Opens comment list dialog that shows all comments which are commented on this post.
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CommentsList(
                                getPostId: postId,
                                getUserId: postUserId,
                              );
                            });
                      },
                      child: Text('View all $comments comments'))
                // If number of comments is greater than 0 and less than 1, it show view 1 comment.
                else
                  GestureDetector(
                      onTap: () {
                        // Opens comment list dialog that shows 1 comment which is commented on this post.
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CommentsList(
                                getPostId: postId,
                                getUserId: postUserId,
                              );
                            });
                      },
                      child: const Text('View 1 Comment')),
              const SizedBox(
                height: 2,
              ),
              // Formatted date.
              Text(
                DateFormat().add_d().add_MMMM().add_y().format(posted.toDate()),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Displays 3D image post using Panorama widget.
class ImagePost extends StatelessWidget {
  const ImagePost({super.key, required this.postUrl});

  final String postUrl;

  @override
  Widget build(BuildContext context) {
    return Panorama(
      child: Image.network(
        postUrl,
        cacheHeight: 1000,
        cacheWidth: 500,
      ),
    );
  }
}

/// Displays 3D video post using Video360View widget.
class VideoPost extends StatefulWidget {
  const VideoPost({super.key, required this.postUrl});

  final String postUrl;

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late Video360Controller? controller;
  String durationText = '';
  String totalText = '';
  bool play = false;

  @override
  void initState() {
    super.initState();
  }

  void playPause() {
    if (play == true) {
      controller?.stop();

      setState(() {
        play = false;
      });
    } else {
      controller?.play();

      setState(() {
        play = true;
      });
    }
  }

  void onVideo360ViewCreated(Video360Controller? controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    controller?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: playPause,
      child: Video360View(
        onVideo360ViewCreated: onVideo360ViewCreated,
        url: widget.postUrl,
        isAutoPlay: false,
      ),
    );
  }
}

/// Displays all comments of a post in a dialog.
class CommentsList extends StatefulWidget {
  const CommentsList(
      {super.key, required this.getPostId, required this.getUserId});

  final String getPostId;
  final String getUserId;

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  late TextEditingController commentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentController = TextEditingController();
  }

  void closeTap(BuildContext context) {
    context.pop();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initializing user interaction methods.
    final obj = UserInteractionsMethodRepository();
    // Initializing user data methods.
    final userObj = UserDataMethods();
    // Initializing firebase auth.
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    return Dialog(
      backgroundColor: const Color.fromRGBO(253, 251, 251, 0),
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(20, 30),
              topRight: Radius.elliptical(20, 30)),
          color: Color.fromRGBO(42, 42, 42, 1.0),
        ),
        child: Column(
          children: [
            // Closes dialog when dragged down.
            GestureDetector(
              onVerticalDragDown: (DragDownDetails v) {
                closeTap(context);
              },
              child: Column(
                children: [
                  // Comments heading
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        height: 5,
                        width: 50,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Comments'),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 2,
                )),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                // Listing all comments that are commented by users.
                child: StreamBuilder(
                  stream: obj.getComments(
                      getUserId: widget.getUserId, getPostId: widget.getPostId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Comments>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        data;
                        if (data!.isNotEmpty) {
                          return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              // Displays each comment.
                              return CommentCard(
                                userId: data[index].userId,
                                comment: data[index].comment,
                                posted: data[index].posted,
                                commentId: data[index].commentId,
                                postId: widget.getPostId,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: snapshot.data!.length,
                          );
                        } else {
                          return const Center(
                            child: Text('No Comments Yet'),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something Went Wrong'),
                        );
                      }
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text('waiting'),
                      );
                    }
                    return const Center(
                      child: Text(''),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  // Displays app user's profile image in comment text field row.
                  FutureBuilder(
                    future: userObj.getUserData(
                        userId: authInstance.currentUser!.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<UserModel> snapshot) {
                      if (snapshot.hasData) {
                        final userData = snapshot.data;
                        return CircleAvatar(
                          radius: 20,
                          backgroundImage: userData != null
                              ? NetworkImage(userData.profilePic)
                              : const AssetImage(
                                  'assets/images/default_user_profile_pic.jpg',
                                ) as ImageProvider,
                        );
                      }
                      if (snapshot.hasError) {
                        return const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              'assets/images/default_user_profile_pic.jpg',
                            ));
                      }
                      return const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            'assets/images/default_user_profile_pic.jpg',
                          ));
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  // Text field for adding comment.
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                          hintText: 'Add Comments',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)
                          //   filled: true
                          ),
                    ),
                  ),
                  // Icon button for posting typed comment.
                  IconButton(
                      onPressed: () async {
                        if (commentController.text.isNotEmpty) {
                          String result = await obj.postComment(
                              comment: commentController.text,
                              getUserId: widget.getUserId,
                              getPostId: widget.getPostId);
                          if (result == "Success") {
                            commentController.clear();
                          }
                        }
                      },
                      icon: const Icon(CupertinoIcons.paperplane))
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            )
          ],
        ),
      ),
    );
  }
}

/// Custom clipper for clipping post boundary.
class PostClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();
    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

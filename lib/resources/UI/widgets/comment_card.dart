import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/UI/widgets/dialogs.dart';

/// Comment card displaying individual comment.
class CommentCard extends StatelessWidget {
  const CommentCard(
      {super.key,
      required this.userId,
      required this.comment,
      required this.posted,
      required this.commentId,
      required this.postId});

  final String userId;
  final String comment;
  final String commentId;
  final String postId;
  final Timestamp posted;

  @override
  Widget build(BuildContext context) {
    // Initializing user data methods.
    final obj = UserDataMethodsRepository();
    // Initializing firebase auth.
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    return FutureBuilder(
      future: obj.getUserData(userId: userId),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Profile image of commenting user.
                CircleAvatar(
                  backgroundImage: NetworkImage(data!.profilePic),
                  radius: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Name of commenting user.
                          Text(
                            data.userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          // Date of comment posted.
                          Text(
                              '${posted.toDate().day} ${posted.toDate().month} ${posted.toDate().year}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey)),
                          const SizedBox(
                            width: 15,
                          ),
                          // Checks if userId is of app user.
                          if (userId == authInstance.currentUser!.uid)
                            GestureDetector(
                              onTap: () {
                                // If userId is of app user, then there will be option to delete posted comment.
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Opens delete comment confirmation dialog.
                                      return DeleteCommentConfirmDialog(
                                        commentId: commentId,
                                        postId: postId,
                                        userId: userId,
                                      );
                                    });
                              },
                              child: const Text('Delete Comment',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blueGrey)),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // Comment posted by user.
                      Text(
                        comment,
                        textAlign: TextAlign.justify,
                        maxLines: 100,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
          // Show nothing if error occurs.
        } else if (snapshot.hasError) {}
        return const Text('');
      },
    );
  }
}

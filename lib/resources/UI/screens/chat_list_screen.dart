import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta360/interfaces/chat_method_repository.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/chat_message_model.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/UI/screens/chat_messages.dart';

/// Defines screen for user's chat list.
class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: const Text('Chats'),
        ),
      ),
      body: const ChatListBody(),
    ));
  }
}

// Defines user's chat list screen body.
class ChatListBody extends StatelessWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing chat methods.
    final obj = ChatMethodRepository();
    return StreamBuilder(
      stream: obj.getChats(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;
            data;
            if (data.isEmpty) {
              return const Center(child: Text('No chats'));
            } else {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                // Opens chat messages with other user.
                                return ChatMessages(userId: data[index].id);
                              },
                            ),
                          );
                        },
                        // Display chat card of other users with whom app user had conversation.
                        child: UserChatCard(
                          getUserId: data[index].id,
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: data.length);
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No Messages'),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return const Center(
          child: Text('No Messages'),
        );
      },
    );
  }
}

/// Defines chat card of other users with whom app user had conversation.
class UserChatCard extends StatelessWidget {
  const UserChatCard({super.key, required this.getUserId});

  final String getUserId;

  @override
  Widget build(BuildContext context) {
    // Initialize user data methods.
    final obj = UserDataMethodsRepository();
    // Initialize chat methods.
    final chatObj = ChatMethodRepository();
    return FutureBuilder(
      // Gets user's data from user id passed as argument.
      future: obj.getUserData(userId: getUserId),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  // Display user's profile image.
                  backgroundImage: userData != null
                      ? NetworkImage(userData.profilePic)
                      : const AssetImage(
                          'assets/images/default_user_profile_pic.jpg',
                        ) as ImageProvider,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display user's name.
                      Text('${userData!.firstName} ${userData.lastName}'),
                      const SizedBox(
                        height: 5,
                      ),
                      StreamBuilder(
                        // Gets chat messages with user.
                        stream: chatObj.getChatMessages(userId: getUserId),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ChatMessageModel>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              final msg = snapshot.data!;
                              if (msg.isNotEmpty) {
                                // Displays latest message with user.
                                final latestMsg = msg.first;
                                return Text(latestMsg.message);
                              }
                            } else if (snapshot.hasError) {
                              return const SizedBox(
                                height: 1,
                              );
                            }
                            return const SizedBox(
                              height: 1,
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 1,
                            );
                          }
                          return const SizedBox(
                            height: 1,
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    'assets/images/default_user_profile_pic.jpg',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    Text('user'),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  'assets/images/default_user_profile_pic.jpg',
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Text('user'),
                  SizedBox(
                    height: 5,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

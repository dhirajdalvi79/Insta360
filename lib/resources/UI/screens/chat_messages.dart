import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta360/interfaces/chat_method_repository.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/chat_message_model.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/utilities/colors.dart';

/// Defines chat messages screen.
class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    // Initialize user data methods.
    final obj = UserDataMethodsRepository();
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: FutureBuilder(
            // Gets data of user with whom app user is chatting.
            future: obj.getUserData(userId: userId),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      // Display profile image of user.
                      backgroundImage: userData != null
                          ? NetworkImage(userData.profilePic)
                          : const AssetImage(
                              'assets/images/default_user_profile_pic.jpg',
                            ) as ImageProvider,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    // Display name of user.
                    Text('${userData!.firstName} ${userData.lastName}')
                  ],
                );
              } else if (snapshot.hasError) {
                return const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        'assets/images/default_user_profile_pic.jpg',
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('User')
                  ],
                );
              }
              return const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                      'assets/images/default_user_profile_pic.jpg',
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('User')
                ],
              );
            },
          ),
        ),
      ),
      body: ChatMessageBody(
        getUserId: userId,
      ),
    ));
  }
}

/// Defines chat messages screen body.
class ChatMessageBody extends StatefulWidget {
  const ChatMessageBody({super.key, required this.getUserId});

  final String getUserId;

  @override
  State<ChatMessageBody> createState() => _ChatMessageBodyState();
}

class _ChatMessageBodyState extends State<ChatMessageBody> {
  late TextEditingController chatTextController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    chatTextController = TextEditingController();
    scrollController = ScrollController();
    //scrollController.position.maxScrollExtent;
  }

  @override
  void dispose() {
    chatTextController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize firebase auth.
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    // Initialize chat methods.
    final obj = ChatMethodRepository();
    return StreamBuilder(
      // Gets all chat messages.
      stream: obj.getChatMessages(userId: widget.getUserId),
      builder: (BuildContext context,
          AsyncSnapshot<List<ChatMessageModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            // Display chat messages if there message exists between users.
            if (data != null) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.separated(
                          // Reverse is set to true for displaying latest message at bottom.
                          reverse: true,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            // Gets date of message.
                            final time = data[index].posted.toDate();
                            // Checks if message is from app user or other user.
                            if (data[index].fromUserId ==
                                authInstance.currentUser!.uid) {
                              // If message is from app user then it will align right.
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                            fit: FlexFit.loose,
                                            // Display text message.
                                            child: Text(data[index].message)),
                                        Text(
                                          '${time.hour}:${time.minute}',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.blueGrey),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            // If message is from other user, then it will align to the left.
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: primaryColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                          fit: FlexFit.loose,
                                          // Display text message.
                                          child: Text(data[index].message)),
                                      Text(
                                        '${time.hour}:${time.minute}',
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.blueGrey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: data.length),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          // Text field for text message.
                          child: TextField(
                            controller: chatTextController,
                            decoration: const InputDecoration(
                                hintText: 'Send Message',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10)
                                //   filled: true
                                ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              // Post text message if message is not an empty text.
                              if (chatTextController.text.isNotEmpty) {
                                await obj.postMessage(
                                    getToUserId: widget.getUserId,
                                    textMessage: chatTextController.text);
                                chatTextController.clear();
                              }
                            },
                            icon: const Icon(CupertinoIcons.paperplane))
                      ],
                    ),
                  )
                ],
              );
            }
            // Display empty container if chat messages hasn't been share between users.
            return Column(
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        // Text field for text message.
                        child: TextField(
                          controller: chatTextController,
                          decoration: const InputDecoration(
                              hintText: 'Send Message',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10)
                              //   filled: true
                              ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            // Post text message if message is not empty text.
                            if (chatTextController.text.isNotEmpty) {
                              await obj.postMessage(
                                  getToUserId: widget.getUserId,
                                  textMessage: chatTextController.text);
                              chatTextController.clear();
                            }
                          },
                          icon: const Icon(CupertinoIcons.paperplane))
                    ],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

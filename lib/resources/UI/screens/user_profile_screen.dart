import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta360/bussiness_logic/providers/theme_providers.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/UI/screens/account.dart';
import 'package:insta360/resources/UI/screens/chat_messages.dart';
import 'package:insta360/resources/UI/screens/following_or_followers_list.dart';
import 'package:insta360/resources/UI/screens/settings.dart';
import 'package:insta360/resources/UI/widgets/bottom_navigation_bar.dart';
import 'package:insta360/resources/UI/widgets/dialogs.dart';
import 'package:insta360/resources/UI/widgets/image_grid.dart';
import 'package:insta360/resources/UI/widgets/mybutton.dart';
import 'package:insta360/resources/utilities/colors.dart';
import 'package:insta360/resources/utilities/constants.dart';
import 'package:insta360/services/theme_cache.dart';
import 'package:provider/provider.dart';

/// Display user profile.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);
  final String? userId;

  @override
  Widget build(BuildContext context) {
    // Initializing user data methods.
    final obj = UserDataMethodsRepository();
    // If app user opens his own profile screen, then userId is set to null
    // and if app user opens other user's profile screen then other user's userId is passed as argument.
    // If userId is not null, other user's profile screen body is displayed.
    return userId != null
        ? Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: FutureBuilder(
                  future: obj.getUserData(userId: userId!),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.hasData) {
                      final userData = snapshot.data;
                      return Text('${userData?.userName}');
                    }
                    if (snapshot.hasError) {
                      return const Text('User');
                    }
                    return const Text('User');
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const OptionDialog();
                            });
                      },
                      icon: const Icon(Icons.menu)),
                )
              ],
            ),
            body: UserProfileContent(
              getUserId: userId,
            ),
            bottomNavigationBar: const AppBottomNavigation(),
          )
        // If userId is null then app user's own profile screen body is displayed.
        : UserProfileContent(
            getUserId: userId,
          );
  }
}

/// Display user profile screen body.
class UserProfileContent extends StatefulWidget {
  const UserProfileContent({Key? key, this.getUserId}) : super(key: key);
  final String? getUserId;

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  // Initial button color.
  Color buttonColor = primaryColor;

  // Initial button text.
  String buttonText = 'Follow';
  late String checkedUserId;
  late FirebaseAuth authInstance;

  // Button color and text is changed after followed event is called.
  void followed() {
    setState(() {
      buttonColor = Colors.black54;
      buttonText = 'Requested';
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize firebase auth.
    authInstance = FirebaseAuth.instance;
    // Checks if userId is null.
    if (widget.getUserId != null) {
      // If userId is not null then it assigned from passed argument.
      checkedUserId = widget.getUserId!;
    } else {
      // If userId is null then it is set to app user's userId.
      checkedUserId = authInstance.currentUser!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize user data method.
    final obj = UserDataMethodsRepository();
    // Initialize user interaction method.
    final objInteraction = UserInteractionsMethodRepository();
    return FutureBuilder(
      future: obj.getUserData(
          userId: widget.getUserId ?? authInstance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data;
          // Custom scroll view is used to apply persistent tab.
          return CustomScrollView(
            slivers: [
              // Displays top main header displaying user information.
              SliverList(
                  delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Container(
                      width: 160,
                      padding:
                          const EdgeInsets.only(left: 25, top: 5, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Display profile image
                          CircleAvatar(
                              radius: 40,
                              backgroundImage: userData != null
                                  ? NetworkImage(userData.profilePic)
                                  : const AssetImage(
                                      'assets/images/default_user_profile_pic.jpg',
                                    ) as ImageProvider),
                          const SizedBox(
                            height: 5,
                          ),
                          // Display user name
                          Text(
                            '${userData!.firstName} ${userData.lastName}',
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Display number of posts
                        Text(
                          '${userData.postCount}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const Text(
                          'Posts',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        // Opens followers list
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return FollowingOrFollowersList(
                                getUserId: widget.getUserId ??
                                    authInstance.currentUser!.uid,
                                getIndex: 1,
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            // Display number of followers
                            '${userData.followersCount}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Text(
                            'Followers',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        // Opens following list
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return FollowingOrFollowersList(
                                getUserId: widget.getUserId ??
                                    authInstance.currentUser!.uid,
                                getIndex: 0,
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            // Display number of users app user is following
                            '${userData.followingCount}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Text(
                            'Following',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 25,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: checkedUserId == authInstance.currentUser!.uid
                              // If checkUserId is app user id, then edit profile button is displayed.
                              ? MyButton(
                                  buttonText: 'Edit Profile',
                                  buttonHeight: 33,
                                  onButtonPressed: () {})
                              // If checkUserId is not app user id, the follow status is displayed with button.
                              : FutureBuilder(
                                  future: objInteraction.checkFollow(
                                      getUserId: widget.getUserId!),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<FollowStatus> snapshot) {
                                    if (snapshot.hasData) {
                                      // Gets follow status
                                      FollowStatus followStatus =
                                          snapshot.data!;
                                      if (followStatus ==
                                          FollowStatus.notInAnyList) {
                                        // If follow status is not in any list then, button text will be default value of 'Follow'.
                                        return MyButton(
                                            buttonHeight: 33,
                                            buttonText: buttonText,
                                            color: buttonColor,
                                            onButtonPressed: () async {
                                              // Send follow request to user.
                                              String result =
                                                  await objInteraction.follow(
                                                      receiverFollowId:
                                                          widget.getUserId!);
                                              // Button state is changed.
                                              if (result == 'Success') {
                                                followed();
                                              }
                                            });
                                      } else if (followStatus ==
                                          FollowStatus.inFollowRequestList) {
                                        // If follow status is in follow request list, then it display text with 'Requested'
                                        // without any action to perform.
                                        return MyButton(
                                            buttonHeight: 33,
                                            buttonText: 'Requested',
                                            color: Colors.black54,
                                            onButtonPressed: () {});
                                      } else {
                                        // If follow status is not in follow request list, then 'Following' is displayed
                                        // without any action to perform.
                                        return MyButton(
                                            buttonHeight: 33,
                                            buttonText: 'Following',
                                            color: Colors.black54,
                                            onButtonPressed: () {});
                                      }
                                    } else if (snapshot.hasError) {
                                      return MyButton(
                                          buttonHeight: 33,
                                          buttonText: 'Follow',
                                          onButtonPressed: () {});
                                    }
                                    return MyButton(
                                        buttonHeight: 33,
                                        buttonText: 'Follow',
                                        onButtonPressed: () {});
                                  },
                                )),
                      const SizedBox(
                        width: 7,
                      ),
                      // Display message button
                      Expanded(
                          child: MyButton(
                              buttonText: 'Message',
                              buttonHeight: 33,
                              onButtonPressed: () {
                                if (widget.getUserId == null) {
                                  // If userId is null i.e. app user, it opens app users chat list.
                                  context.goNamed(chatListScreen);
                                } else {
                                  // If userId not null, it opens chat messages with user.
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ChatMessages(
                                            userId: widget.getUserId!);
                                      },
                                    ),
                                  );
                                }
                              })),
                      const SizedBox(
                        width: 7,
                      ),
                      // TODO: Events to be added.
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            height: 32,
                            width: 32,
                            color: primaryColor,
                            child: const Icon(
                              Icons.person_add_alt,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ])),
              // Display persistent tab bar.
              SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeader(
                      widget: const DefaultTabController(
                    length: 2,
                    child: TabBar(
                      indicatorWeight: 2.5,
                      //labelPadding: EdgeInsets.symmetric(vertical: 1),
                      tabs: [
                        // Icon for image post grid
                        Icon(
                          Icons.grid_on_rounded,
                          size: 22,
                        ),
                        // Icon for video post grid
                        Icon(Icons.video_collection, size: 22),
                      ],
                    ),
                  ))),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 2,
                )
              ])),
              // TODO: Video grid to be added with image grid in list
              ImageGrid(
                user: userData.id,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 50,
                )
              ]))
            ],
          );
        }
        if (snapshot.hasError) {
          return const Text('User');
        }
        return const Text('User');
      },
    );
  }
}

/// Delegate for persistent header used in persistent tab in custom scroll view.
class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<ThemeProvider>(
      builder: (context, obj, __) {
        return obj.getTheme == CacheMemory.darkTheme
            ? Container(
                color: Colors.black,
                width: double.infinity,
                height: 50.0,
                child: widget,
              )
            : Container(
                color: Colors.grey,
                width: double.infinity,
                height: 50.0,
                child: widget,
              );
      },
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// General list tile which can be set with custom arguments passed.
/// This is reused in option dialog for multiple options in dialog.
class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {Key? key,
      required this.onTileTap,
      required this.leading,
      required this.title})
      : super(key: key);
  final VoidCallback? onTileTap;
  final Widget leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: leading),
          const SizedBox(
            width: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: title),
        ],
      ),
    );
  }
}

/// Dialog displayed when user tap on options on user profile screen.
class OptionDialog extends StatelessWidget {
  const OptionDialog({Key? key}) : super(key: key);

  // Close event for option dialog.
  void closeTap(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dialog is popped when it is dragged down.
      onVerticalDragDown: (DragDownDetails v) {
        closeTap(context);
      },
      child: Dialog(
        backgroundColor: const Color.fromRGBO(253, 251, 251, 0),
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        // Getting theme provider.
        child: Consumer<ThemeProvider>(
          builder: (context, obj, __) {
            // Display option dialog with respect to theme.
            return obj.getTheme == CacheMemory.darkTheme
                ? Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(20, 30),
                          topRight: Radius.elliptical(20, 30)),
                      color: Color.fromRGBO(42, 42, 42, 1.0),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: Column(
                      children: [
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            // Listing of list tile with actions.
                            child: ListView(
                              children: [
                                // List tile for settings
                                CustomListTile(
                                  onTileTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const Settings();
                                        },
                                      ),
                                    );
                                  },
                                  leading: const Icon(CupertinoIcons.settings),
                                  title: const Text('Settings'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // List tile for saved post.
                                CustomListTile(
                                  onTileTap: () {},
                                  leading: const Icon(CupertinoIcons.bookmark),
                                  title: const Text('Saved'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // List tile for account.
                                CustomListTile(
                                  onTileTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const Account();
                                        },
                                      ),
                                    );
                                  },
                                  leading: const Icon(CupertinoIcons.person),
                                  title: const Text('Account'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // List tile for log out.
                                CustomListTile(
                                  onTileTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ConfirmLogout();
                                        });
                                  },
                                  leading: const Icon(Icons.logout),
                                  title: const Text('Log Out'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(20, 30),
                          topRight: Radius.elliptical(20, 30)),
                      color: Colors.grey,
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: Column(
                      children: [
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            // Listing of list tile with actions.
                            child: ListView(
                              children: [
                                // List tile for settings
                                CustomListTile(
                                  onTileTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const Settings();
                                        },
                                      ),
                                    );
                                  },
                                  leading: const Icon(CupertinoIcons.settings),
                                  title: const Text('Settings'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // List tile for saved post.
                                CustomListTile(
                                  onTileTap: () {},
                                  leading: const Icon(CupertinoIcons.bookmark),
                                  title: const Text('Saved'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // List tile for account.
                                CustomListTile(
                                  onTileTap: () {},
                                  leading: const Icon(CupertinoIcons.person),
                                  title: const Text('Account'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // List tile for log out.
                                CustomListTile(
                                  onTileTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ConfirmLogout();
                                        });
                                  },
                                  leading: const Icon(Icons.logout),
                                  title: const Text('Log Out'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

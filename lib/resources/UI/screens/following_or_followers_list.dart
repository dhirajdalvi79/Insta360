import 'package:flutter/material.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/UI/screens/user_profile_screen.dart';
import 'package:insta360/resources/UI/widgets/user_cards.dart';

/// Display followers or following list of user with respect to selected tab.
class FollowingOrFollowersList extends StatefulWidget {
  const FollowingOrFollowersList(
      {super.key, required this.getUserId, required this.getIndex});

  final String getUserId;
  final int getIndex;

  @override
  State<FollowingOrFollowersList> createState() =>
      _FollowingOrFollowersListState();
}

class _FollowingOrFollowersListState extends State<FollowingOrFollowersList> {
  // Widget list for holding follower and following widget.
  late List<Widget> followingOrFollowersList;
  late int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.getIndex;
    // Initializing with two widgets i.e. following list and followers list.
    followingOrFollowersList = [
      FollowingList(
        user: widget.getUserId,
      ),
      FollowersList(
        user: widget.getUserId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        // Creating two tabs with default tab controller.
        child: DefaultTabController(
      initialIndex: index,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            tabs: const [
              SizedBox(
                height: 40,
                child: Center(child: Text('Following')),
              ),
              SizedBox(
                height: 40,
                child: Center(child: Text('Followers')),
              ),
            ],
            onTap: (int tabIndex) {
              setState(() {
                index = tabIndex;
              });
            },
          ),
        ),
        body: followingOrFollowersList[index],
      ),
    ));
  }
}

/// Creates user's following list.
class FollowingList extends StatelessWidget {
  const FollowingList({super.key, required this.user});

  final String user;

  @override
  Widget build(BuildContext context) {
    final obj = UserDataMethodsRepository();
    return FutureBuilder(
      future: obj.getFollowing(userId: user),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data!.isNotEmpty) {
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  int newIndex = index - 1;
                  if (index == 0) {
                    return const SizedBox(
                      height: 5,
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          // Opens user's profile screen on tap.
                          // Using this method of routing instead of context goNamed in go_router because, this method
                          // is already used in previous screen in stack and by using go_router method the screen gets
                          // stacked between previous and current screen, not on top.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return UserProfileScreen(
                                  userId: data[newIndex].id,
                                );
                              },
                            ),
                          );
                        },
                        // Defines user details in card.
                        child: UserCardHorizontal(
                            imageUrl: data[newIndex].profilePic,
                            firstName: data[newIndex].firstName,
                            lastName: data[newIndex].lastName,
                            userName: data[newIndex].userName,
                            userId: data[newIndex].id),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return const SizedBox(
                      height: 10,
                    );
                  }
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: data.length + 1);
          } else {
            return const Center(
              child: Text('No One In Following List'),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        return const Center(
          child: Text('Something wrong'),
        );
      },
    );
  }
}

/// Creates user's followers list.
class FollowersList extends StatelessWidget {
  const FollowersList({super.key, required this.user});

  final String user;

  @override
  Widget build(BuildContext context) {
    final obj = UserDataMethodsRepository();
    return FutureBuilder(
      future: obj.getFollowers(userId: user),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data!.isNotEmpty) {
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  int newIndex = index - 1;
                  if (index == 0) {
                    return const SizedBox(
                      height: 5,
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          // Opens user's profile screen on tap.
                          // Using this method of routing instead of context goNamed in go_router because, this method
                          // is already used in previous screen in stack and by using go_router method the screen gets
                          // stacked between previous and current screen, not on top.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return UserProfileScreen(
                                  userId: data[newIndex].id,
                                );
                              },
                            ),
                          );
                        },
                        // Defines user details in card.
                        child: UserCardHorizontal(
                            imageUrl: data[newIndex].profilePic,
                            firstName: data[newIndex].firstName,
                            lastName: data[newIndex].lastName,
                            userName: data[newIndex].userName,
                            userId: data[newIndex].id),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return const SizedBox(
                      height: 10,
                    );
                  }
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: data.length + 1);
          } else {
            return const Center(
              child: Text('No Followers'),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        return const Center(
          child: Text('Something wrong'),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/resources/utilities/colors.dart';
import 'package:insta360/resources/utilities/constants.dart';
import 'mybutton.dart';

/// Displays horizontal user card.
class UserCardHorizontal extends StatelessWidget {
  const UserCardHorizontal(
      {Key? key,
      required this.imageUrl,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.userId})
      : super(key: key);
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String userName;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromRGBO(42, 42, 42, 1.0),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        children: [
          // Displays user's profile image.
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Displays user's username.
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 17),
                  ),
                  // displays user's full name.
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Displays vertical user card.
class UserCardVertical extends StatefulWidget {
  const UserCardVertical(
      {Key? key,
      required this.imageUrl,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.userId})
      : super(key: key);
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String userName;
  final String userId;

  @override
  State<UserCardVertical> createState() => _UserCardVerticalState();
}

class _UserCardVerticalState extends State<UserCardVertical> {
  // Initial button color.
  Color buttonColor = primaryColor;

  // Initial button text.
  String buttonText = 'Follow';

  // Button color and text is changed after followed event is called.
  void followed() {
    setState(() {
      buttonColor = Colors.black54;
      buttonText = 'Requested';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize user interaction method.
    final obj = UserInteractionsMethodRepository();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromRGBO(42, 42, 42, 1.0),
      ),
      height: 180,
      width: 135,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed(userProfileScreen, pathParameters: {
                    "user_id": widget.userId,
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display user's profile image
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Displays user's username
                    Text(
                      widget.userName,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    // Displays user's full name
                    Text(
                      '${widget.firstName} ${widget.lastName}',
                      style: const TextStyle(
                          fontSize: 14, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Center(
                  child: FutureBuilder(
                future: obj.checkFollow(getUserId: widget.userId),
                builder: (BuildContext context,
                    AsyncSnapshot<FollowStatus> snapshot) {
                  if (snapshot.hasData) {
                    // Gets follow status
                    FollowStatus followStatus = snapshot.data!;
                    if (followStatus == FollowStatus.notInAnyList) {
                      // If follow status is not in any list then, button text will be default value of 'Follow'.
                      return MyButton(
                          buttonWidth: 120,
                          buttonText: buttonText,
                          color: buttonColor,
                          onButtonPressed: () async {
                            // Send follow request to user.
                            String result = await obj.follow(
                                receiverFollowId: widget.userId);
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
                          buttonWidth: 120,
                          buttonText: 'Requested',
                          color: Colors.black54,
                          onButtonPressed: () {});
                    } else {
                      // If follow status is not in follow request list, then 'Following' is displayed
                      // without any action to perform.
                      return MyButton(
                          buttonWidth: 120,
                          buttonText: 'Following',
                          color: Colors.black54,
                          onButtonPressed: () {});
                    }
                  } else if (snapshot.hasError) {
                    return MyButton(
                        buttonWidth: 120,
                        buttonText: 'Follow',
                        onButtonPressed: () {});
                  }
                  return MyButton(
                      buttonWidth: 120,
                      buttonText: 'Follow',
                      onButtonPressed: () {});
                },
              ))
            ],
          ),
          // TODO: Implement action for this icon.
          const Positioned(
              top: 5,
              right: 5,
              child: Icon(
                CupertinoIcons.clear,
                size: 18,
              ))
        ],
      ),
    );
  }
}

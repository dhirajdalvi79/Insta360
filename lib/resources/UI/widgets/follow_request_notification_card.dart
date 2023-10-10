import 'package:flutter/material.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/models/user.dart';
import 'package:insta360/resources/utilities/colors.dart';

/// Displays follow request notification from other user.
class FollowRequestNotificationCard extends StatelessWidget {
  const FollowRequestNotificationCard({super.key, required this.getUserId});

  final String getUserId;

  @override
  Widget build(BuildContext context) {
    // Initializing user data methods.
    final obj = UserDataMethodsRepository();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
        future: obj.getUserData(userId: getUserId),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data;
            return Row(
              children: [
                // Other user's profile image.
                CircleAvatar(
                  radius: 18,
                  backgroundImage: userData != null
                      ? NetworkImage(userData.profilePic)
                      : const AssetImage(
                          'assets/images/default_user_profile_pic.jpg',
                        ) as ImageProvider,
                ),
                const SizedBox(
                  width: 10,
                ),
                // Follow request message.
                Expanded(
                    child: Text('${userData!.userName} wants to follow you')),
                // Confirm button.
                TextButton(
                    onPressed: () async {
                      final userObj = UserInteractionsMethodRepository();
                      await userObj.acceptRequest(getUserId: getUserId);
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(primaryColor),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                    ),
                    child: const Text('Confirm')),
                const SizedBox(
                  width: 10,
                ),
                // Delete request button.
                TextButton(
                    onPressed: () async {
                      final userObj = UserInteractionsMethodRepository();
                      await userObj.declineRequest(getUserId: getUserId);
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white12),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                    ),
                    child: const Text('Delete'))
              ],
            );
          }
          if (snapshot.hasError) {
            return const SizedBox();
          }
          return const SizedBox();
        },
      ),
    );
  }
}

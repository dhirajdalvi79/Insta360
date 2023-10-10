import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/resources/UI/widgets/follow_request_notification_card.dart';

// Display notifications
class AppNotifications extends StatelessWidget {
  const AppNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: const Text('Notifications'),
          ),
        ),
        // Currently notification display only follow request sent by other users.
        body: const FollowRequests());
  }
}

// Displays list of follow request sent by other users.
class FollowRequests extends StatelessWidget {
  const FollowRequests({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing user interaction methods.
    final obj = UserInteractionsMethodRepository();
    return StreamBuilder(
      // Gets follow request.
      stream: obj.checkFollowRequest(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  // Display follow request notification card.
                  return FollowRequestNotificationCard(
                    getUserId: data[index].data()["from_user"],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: data.length);
          } else if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('waiting');
        }
        return const Text('waiting');
      },
    );
  }
}

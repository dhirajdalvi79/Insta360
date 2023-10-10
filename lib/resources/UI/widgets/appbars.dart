import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/interfaces/user_interaction_methods_repository.dart';
import 'package:insta360/models/user.dart';
import 'package:provider/provider.dart';
import '../../../bussiness_logic/providers/theme_providers.dart';
import '../../../services/theme_cache.dart';
import '../../utilities/constants.dart';
import '../screens/search.dart';
import '../screens/user_profile_screen.dart';

/// Default main screen app bar when home screen is set from bottom navigation bar.
class MainScreenAppBar extends StatelessWidget {
  const MainScreenAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initializing user interaction methods.
    final obj = UserInteractionsMethodRepository();
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'Insta360',
          style: GoogleFonts.satisfy(
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  // Opens notification.
                  context.goNamed(appNotifications);
                },
                icon: const Icon(Icons.notifications_outlined)),
            StreamBuilder(
              // Gets follow request data.
              stream: obj.checkFollowRequest(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;
                    // Checks if follow request collection has requests.
                    if (data.isNotEmpty) {
                      // If follow request collection has request, the icon will display red dot on top right.
                      return Positioned(
                        right: 13,
                        top: 13,
                        child: ClipOval(
                          child: Container(
                            height: 8,
                            width: 8,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                  }
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              // Opens chat list screen.
              context.goNamed(chatListScreen);
            },
            icon: const Icon(CupertinoIcons.bubble_right)),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}

/// Search screen appbar, having search text box.
class SearchTap extends StatelessWidget {
  const SearchTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: GestureDetector(onTap: () {
          // On tap it opens dialog for search in app.
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SearchScreenDialog();
              });
        }, child: Consumer<ThemeProvider>(
          builder: (context, obj, __) {
            // Defines search text bar.
            return Container(
                height: 30,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: obj.getTheme == CacheMemory.darkTheme
                        ? const Color.fromRGBO(71, 72, 73, 1.0)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(5)),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 15),
                ));
          },
        )),
      ),
    );
  }
}

/// Appbar for users profile screen which display app user's name.
class UserProfileScreenAppBar extends StatelessWidget {
  const UserProfileScreenAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize user data methods.
    final obj = UserDataMethodsRepository();
    // Initialize firebase auth.
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: FutureBuilder(
          future: obj.getUserData(userId: authInstance.currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
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
                // Opens option dialog.
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const OptionDialog();
                    });
              },
              icon: const Icon(Icons.menu)),
        )
      ],
    );
  }
}

/// Appbar for add post screen.
class AddPostAppBar extends StatelessWidget {
  const AddPostAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text("New Post"),
      ),
    );
  }
}

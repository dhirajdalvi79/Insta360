import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta360/bussiness_logic/providers/profile_image_state.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/resources/UI/widgets/dialogs.dart';
import 'package:insta360/resources/utilities/constants.dart';
import 'package:insta360/screen_size.dart';
import 'package:provider/provider.dart';

/// Defines user account screen.
class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: const Text('Account'),
        ),
      ),
      body: const AccountBody(),
    ));
  }
}

/// Defines user account screen body.
class AccountBody extends StatelessWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing user data methods.
    final obj = UserDataMethodsRepository();
    // Initializing media query to get screen size.
    final screen = ScreenSizeConfig.screen(context: context);
    return StreamBuilder(
      stream: obj.getUserDataStream(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User's data
            final userData = snapshot.data!.data();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        // Consuming profile image selector provider for user's profile image state
                        Consumer<ProfileImageSelector>(
                            builder: (context, obj, __) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: iconSize / 2),
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: screen.screenWidth * 0.20,
                                backgroundImage:
                                    // If profile image is not null in user data, then it will render image profile
                                    // image from storage, else if it is null then it will render default image from asset.
                                    userData!['profile_pic'] != null
                                        ? NetworkImage(userData['profile_pic'])
                                        : const AssetImage(
                                            'assets/images/default_user_profile_pic.jpg',
                                          ) as ImageProvider),
                          );
                        }),
                        Positioned(
                            // Evaluation for fixing icon at centre
                            left: (screen.screenWidth * 0.20) - iconSize / 2,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Returns a dialog for selecting the source for uploading image
                                      // e.g. image gallery or camera.
                                      return const ImageSourceSelectorDialogForUpdateProfilePic();
                                    });
                              },
                              child: const Icon(
                                Icons.add_a_photo_sharp,
                                size: iconSize,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Text('${userData![UserDataProperty.firstName]}')),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Returns dialog for updating user data.
                                  return const EditDialog(
                                    property: UserDataProperty.firstName,
                                    displayProperty: 'First Name',
                                  );
                                });
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Text('${userData[UserDataProperty.lastName]}')),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Returns dialog for updating user data.
                                  return const EditDialog(
                                    property: UserDataProperty.lastName,
                                    displayProperty: 'Last Name',
                                  );
                                });
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Text('${userData[UserDataProperty.userName]}')),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Returns dialog for updating user data.
                                  return const EditDialog(
                                    property: UserDataProperty.userName,
                                    displayProperty: 'Username',
                                  );
                                });
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}

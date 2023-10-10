import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta360/bussiness_logic/providers/screen_state_index.dart';
import 'package:insta360/interfaces/user_data_methods_repository.dart';
import 'package:insta360/models/user.dart';
import 'package:provider/provider.dart';
import '../../../bussiness_logic/providers/theme_providers.dart';
import '../../../services/theme_cache.dart';
import '../../utilities/colors.dart';

/// Display bottom navigation bar.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize user data methods.
    final obj = UserDataMethodsRepository();
    // Initialize firebase auth.
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    // Consuming screen state index and theme provider.
    return Consumer2<ScreenStateIndex, ThemeProvider>(
      builder: (context, screenNumberObj, themeObj, __) {
        return Stack(children: [
          ClipPath(
            // Using custom clipper for bottom navigation bar.
            clipper: BottomNavigationClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: themeObj.getTheme == CacheMemory.darkTheme
                    ? darkThemeBaseColor
                    : lightThemeBaseColor,
              ),
              height: 100,
              width: double.infinity,
              child: CustomPaint(
                // Using custom paint for applying border to clipped bottom navigation bar.
                // Using foreground painter to make border stack on row widgets.
                foregroundPainter: BorderPaint(),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 110,
                    ),
                    Column(
                      children: [
                        Expanded(child: Container()),
                        // Icon for home screen.
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                              onTap: () {
                                // Checks if there is other screen on top of home screen in stack.
                                if (context.canPop()) {
                                  // If there is other screen, then it will be popped.
                                  context.pop();
                                }
                                // Change screen index state to 1, placing home screen in main screen.
                                screenNumberObj.changeScreenIndex(
                                    screenNumber: 1);
                              },
                              child: Icon(
                                Icons.home_filled,
                                color:
                                    (themeObj.getTheme == CacheMemory.darkTheme)
                                        ? (screenNumberObj.index == 1
                                            ? primaryColor
                                            : Colors.white)
                                        : (screenNumberObj.index == 1
                                            ? Colors.purple
                                            : Colors.black),
                              )),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Expanded(child: Container()),
                        // Icon for search screen.
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                              onTap: () {
                                // Checks if there is other screen on top of home screen in stack.
                                if (context.canPop()) {
                                  // If there is other screen, then it will be popped.
                                  context.pop();
                                }
                                // Change screen index state to 2, placing search screen in main screen.
                                screenNumberObj.changeScreenIndex(
                                    screenNumber: 2);
                              },
                              child: Icon(
                                Icons.search,
                                color:
                                    (themeObj.getTheme == CacheMemory.darkTheme)
                                        ? (screenNumberObj.index == 2
                                            ? primaryColor
                                            : Colors.white)
                                        : (screenNumberObj.index == 2
                                            ? Colors.purple
                                            : Colors.black),
                              )),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Expanded(child: Container()),
                        // Icon for add new post screen.
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                              onTap: () {
                                // Checks if there is other screen on top of home screen in stack.
                                if (context.canPop()) {
                                  // If there is other screen, then it will be popped.
                                  context.pop();
                                }
                                // Change screen index state to 3, placing add new post screen in main screen.
                                screenNumberObj.changeScreenIndex(
                                    screenNumber: 3);
                              },
                              child: Icon(
                                Icons.add_box_outlined,
                                color:
                                    (themeObj.getTheme == CacheMemory.darkTheme)
                                        ? (screenNumberObj.index == 3
                                            ? primaryColor
                                            : Colors.white)
                                        : (screenNumberObj.index == 3
                                            ? Colors.purple
                                            : Colors.black),
                              )),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Expanded(child: Container()),
                        // Icon for VR view screen.
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                              onTap: () {
                                // Checks if there is other screen on top of home screen in stack.
                                if (context.canPop()) {
                                  // If there is other screen, then it will be popped.
                                  context.pop();
                                }
                                // Change screen index state to 4, placing VR view screen in main screen.
                                screenNumberObj.changeScreenIndex(
                                    screenNumber: 4);
                              },
                              child: Icon(
                                Icons.vrpano_outlined,
                                color:
                                    (themeObj.getTheme == CacheMemory.darkTheme)
                                        ? (screenNumberObj.index == 4
                                            ? primaryColor
                                            : Colors.white)
                                        : (screenNumberObj.index == 4
                                            ? Colors.purple
                                            : Colors.black),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
          // Placing circle avatar for user's profile image.
          Positioned(
            top: 29,
            left: 18.5,
            child: GestureDetector(
              onTap: () {
                // Checks if there is other screen on top of home screen in stack.
                if (context.canPop()) {
                  // If there is other screen, then it will be popped.
                  context.pop();
                }
                // Change screen index state to 0, placing app user profile in main screen.
                screenNumberObj.changeScreenIndex(screenNumber: 0);
              },
              child: FutureBuilder(
                future: obj.getUserData(userId: authInstance.currentUser!.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.hasData) {
                    final userData = snapshot.data;
                    // This is outer circle avatar for bordering the inner circle avatar.
                    return CircleAvatar(
                      radius: 26.5,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: userData != null
                            ? NetworkImage(userData.profilePic)
                            : const AssetImage(
                                'assets/images/default_user_profile_pic.jpg',
                              ) as ImageProvider,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    // Setting default profile image, in case of error.
                    return const CircleAvatar(
                      radius: 26.5,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assets/images/default_user_profile_pic.jpg',
                          )),
                    );
                  }
                  // Default profile image for loading.
                  return const CircleAvatar(
                    radius: 26.5,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                          'assets/images/default_user_profile_pic.jpg',
                        )),
                  );
                },
              ),
            ),
          )
        ]);
      },
    );
  }
}

/// Custom clipper for bottom navigation bar.
class BottomNavigationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();
    path.moveTo(0, 50);
    path.lineTo(10, 50);
    path.arcToPoint(const Offset(15, 55), radius: const Radius.circular(5));
    path.arcToPoint(const Offset(75, 55),
        radius: const Radius.circular(30), clockwise: false);
    path.arcToPoint(const Offset(80, 50), radius: const Radius.circular(5));
    path.lineTo(w, 50);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Custom paint for applying border to clipped bottom navigation bar.
class BorderPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;

    Path path = Path();
    path.moveTo(0, 50);
    path.lineTo(10, 50);
    path.arcToPoint(const Offset(15, 55), radius: const Radius.circular(5));
    path.arcToPoint(const Offset(75, 55),
        radius: const Radius.circular(30), clockwise: false);
    path.arcToPoint(const Offset(80, 50), radius: const Radius.circular(5));
    path.lineTo(w, 50);
    path.close();

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.grey;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

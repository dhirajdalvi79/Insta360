import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:insta360/resources/UI/screens/chat_list_screen.dart';
import '../resources/UI/screens/login.dart';
import '../resources/UI/screens/main_screen.dart';
import '../resources/UI/screens/notifications.dart';
import '../resources/UI/screens/signup_screen_one.dart';
import '../resources/UI/screens/user_profile_screen.dart';
import '../resources/utilities/constants.dart';

/// Creating route configuration with go router.
class AppRoute {
  final GoRouter routerGo = GoRouter(initialLocation: '/', routes: <RouteBase>[
    // Initial route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return StreamBuilder(
          // Checks stream auth state.
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                if (user != null) {
                  // Returns main screen if user returned from authStateChanges() is not null.
                  return const MainScreen();
                } else {
                  // Else returns login screen.
                  return const LoginScreen();
                }
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something Went Wrong'),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return const Center(
                child: Text('Something Went Wrong'),
              );
            }
            return const LoginScreen();
          },
        );
      },
    ),
    // Route for login screen
    GoRoute(
      path: loginPath,
      name: login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    // Route for signup screen
    GoRoute(
      path: signupPath,
      name: signup,
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreenOne();
      },
    ),
    // Route for main screen
    GoRoute(
        path: mainScreenPath,
        name: mainScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
        },
        // Main screen route has following sub routes.
        routes: [
          // Route for notification screen
          GoRoute(
            path: appNotificationsPath,
            name: appNotifications,
            builder: (BuildContext context, GoRouterState state) {
              return const AppNotifications();
            },
          ),
          // Route for user profile screen
          GoRoute(
            path: userProfileScreenPath,
            name: userProfileScreen,
            builder: (BuildContext context, GoRouterState state) {
              return UserProfileScreen(
                userId: state.pathParameters["user_id"]!,
              );
            },
          ),
          // Route for chat list screen
          GoRoute(
            path: chatListScreenPath,
            name: chatListScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const ChatList();
            },
          ),
        ])
  ]);
}

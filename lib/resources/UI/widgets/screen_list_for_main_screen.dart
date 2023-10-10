import 'package:flutter/material.dart';
import '../screens/add_post.dart';
import '../screens/home.dart';
import '../screens/search.dart';
import '../screens/user_profile_screen.dart';
import '../screens/vr_view.dart';

/// Screen list which are displayed on main screen with respect to screen state.
const List<Widget> screenList = [
  UserProfileScreen(),
  HomeScreen(),
  Explore(),
  AddPost(),
  VrView(),
];

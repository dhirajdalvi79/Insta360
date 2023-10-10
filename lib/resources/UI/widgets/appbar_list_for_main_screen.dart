import 'package:flutter/material.dart';
import 'appbars.dart';

/// Appbar list for main screen appbar.
List appBarList = [
  const UserProfileScreenAppBar(),
  const MainScreenAppBar(),
  const SearchTap(),
  const AddPostAppBar(),
  SafeArea(
      child: AppBar(
    title: const Text('view'),
  )),
];

import 'package:flutter/material.dart';
import 'package:insta360/bussiness_logic/providers/screen_state_index.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar_list_for_main_screen.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/screen_list_for_main_screen.dart';

/// App's main screen which displays many screen with the help of bottom navigation bar.
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Consuming screen state index provider.
    return Consumer<ScreenStateIndex>(
      builder: (context, obj, __) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              // Display app bar from list.
              child: appBarList[obj.index],
            ),
            // Display different screen from list.
            body: screenList[obj.index],
            //extendBody is set to true for preventing clipped container to get visible
            extendBody: true,
            // Bottom navigation bar.
            bottomNavigationBar: const AppBottomNavigation(),
          ),
        );
      },
    );
  }
}

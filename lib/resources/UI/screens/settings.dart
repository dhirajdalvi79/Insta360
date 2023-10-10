import 'package:flutter/material.dart';
import 'package:insta360/bussiness_logic/providers/theme_providers.dart';
import 'package:insta360/services/theme_cache.dart';
import 'package:provider/provider.dart';

/// Settings screen
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: const Text('Settings'),
        ),
      ),
      body: const SettingsBody(),
    );
  }
}

/// Settings screen body
class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              // Toggle for changing theme mode.
              const Expanded(child: Text('Dark Mode')),
              Consumer<ThemeProvider>(builder: (context, obj, __) {
                return Switch(
                    value: obj.getTheme == CacheMemory.darkTheme ? true : false,
                    onChanged: (val) {
                      obj.changeTheme();
                    });
              }),
            ],
          ),
        )
      ],
    );
  }
}

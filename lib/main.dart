import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta360/bussiness_logic/providers/post_type_select_state.dart';
import 'package:insta360/bussiness_logic/providers/progress_indicator_status.dart';
import 'package:insta360/bussiness_logic/providers/screen_state_index.dart';
import 'package:insta360/resources/themes/theme.dart';
import 'package:insta360/routes/routes.dart';
import 'package:insta360/services/theme_cache.dart';
import 'package:provider/provider.dart';
import 'bussiness_logic/providers/profile_image_state.dart';
import 'bussiness_logic/providers/theme_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(const ProviderWrapper());
}

/// Wrapping the root widget with [MultiProvider].
class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ScreenStateIndex()),
        ChangeNotifierProvider(create: (_) => ProfileImageSelector()),
        ChangeNotifierProvider(create: (_) => SelectPostTypeState()),
        ChangeNotifierProvider(create: (_) => ProgressIndicatorStatus()),
      ],
      child: const MyRouteBuilder(),
    );
  }
}

/// Using [MyRouteBuilder] as an intermediate widget because consumer won't work
/// in direct child class with provider.
class MyRouteBuilder extends StatelessWidget {
  const MyRouteBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IgRoot();
  }
}

/// App's root widget that uses material app.
class IgRoot extends StatelessWidget {
  const IgRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initializing go router.
    AppRoute routerMainGo = AppRoute();
    return Consumer<ThemeProvider>(
      builder: (context, obj, __) {
        // Using Material with go router.
        return MaterialApp.router(
          routeInformationParser: routerMainGo.routerGo.routeInformationParser,
          routerDelegate: routerMainGo.routerGo.routerDelegate,
          routeInformationProvider:
              routerMainGo.routerGo.routeInformationProvider,
          theme: obj.getTheme == CacheMemory.darkTheme
              ? MyAppTheme.dark
              : MyAppTheme.light,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

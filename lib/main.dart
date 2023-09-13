import 'package:cloaky/dialogs/dialog_route_generator.dart';
import 'package:cloaky/home_page.dart';
import 'package:cloaky/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:url_strategy/url_strategy.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/logo.jpeg"), context);
    precacheImage(const AssetImage("assets/ghost.jpeg"), context);
    precacheImage(const AssetImage("assets/colorful_ghost.jpeg"), context);
    precacheImage(const AssetImage("assets/happy_ghost.jpeg"), context);

    return DialogManager(
      navigatorKey: _navigatorKey,
      onGenerateDialog: DialogRouteGenerator.onGenerateDialog,
      child: MaterialApp(
        title: 'cloakyy',
        navigatorKey: _navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              minimumSize: MaterialStateProperty.all(
                (const Size(220, 60), const Size(140, 48)).resolve,
              ),
            ),
          ),
        ),
        home: const HomePage(),
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        },
      ),
    );
  }
}

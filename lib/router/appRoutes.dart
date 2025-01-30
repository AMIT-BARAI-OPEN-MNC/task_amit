import 'package:flutter/material.dart';
import 'package:task_amit/views/screens/navbar.dart';
import 'package:task_amit/views/screens/navbar/detailsScreen.dart';
import 'package:task_amit/views/screens/navbar/homeScreem.dart';
import 'package:task_amit/views/screens/splashScreen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/navBar':
        return MaterialPageRoute(builder: (_) => navBar());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}

import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hélé',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => SplashScreen(context),
        '/login': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => HomeScreen()
      }
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animations/loading_animations.dart';

class SplashScreen extends StatelessWidget {

  SplashScreen(BuildContext context) {
    this.getTokenAsync().then((token) {
      if (token != null) {
        // TODO: check if token is valid using the
        // GET /auth/me route to retrieve user profile
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
      //Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<String> getTokenAsync() async {
    await new Future.delayed(const Duration(seconds : 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // int counter = (prefs.getInt('counter') ?? 0) + 1;
    // print('Pressed $counter times.');
    // await prefs.setInt('counter', counter);
    return prefs.getString('jwt_token' ?? null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingBouncingGrid.square(
        backgroundColor: Colors.cyan, inverted: true
      )
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body:
        Center(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Text('HomePage')
          )
        )
    );
  }
}

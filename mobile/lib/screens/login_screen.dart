import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<StatefulWidget> {
  String _phone;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _loginAsync() {
    http.post('http://localhost:3333/v1/auth/login', body: {
      'phone': this._phone,
      'password': this._password
    }).then((response) async {
      print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var res = jsonDecode(response.body);
      await prefs.setString('jwt_token', res['access_token']['token']);
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginScreen'),
      ),
      body:
        Center(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    onSaved: (value) => this._phone = value,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                  TextFormField(
                    onSaved: (value) => this._password = value,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        this._loginAsync();
                      }
                    },
                  )
                ],
              )
            )
          )
        )
    );
  }
}

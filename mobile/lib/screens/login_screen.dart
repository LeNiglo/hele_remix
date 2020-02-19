import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oust/helpers/hele_http_service.dart';
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

  void _loginAsync() async {
    try {
      var response = await heleHttpService.loginWithPhone(_phone, _password);
      print("--- USER id + access token ---");
      print(response.user.id);
      print(response.accessToken.token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response.accessToken.token);
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      if (e is HeleApiException) {
        print("--- ERROR DURING LOGIN ---");
      } else {
        print("--- NETWORK ERROR ---");
      }
      print(e.toString());
    }
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
                  ),
                  RaisedButton(
                    child: Text('Register'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
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

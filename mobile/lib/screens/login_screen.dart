import 'package:flutter/material.dart';
import 'package:oust/helpers/hele_http_service.dart';
import 'package:oust/responses/login_response.dart';
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
      var response = await heleHttpService.call<LoginResponse>('login', body: {'phone': _phone, 'password': _password});
      print("--- USER id + access token ---");
      print(response.user.id);
      print(response.accessToken.token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response.accessToken.token);
      await prefs.setString('jwt_refresh_token', response.accessToken.refreshToken);
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      if (e is HeleApiException) {
        print("--- ERROR DURING LOGIN ---");
      } else {
        print("--- NETWORK OR CODE ERROR ---");
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Vous n'avez pas de compte ? ",
                        children: <TextSpan>[
                          TextSpan(text: 'Enregistrez-vous', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.lightBlue,
                          )),
                        ],
                      ),
                    )
                  ),
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
                ],
              )
            )
          )
        )
    );
  }
}

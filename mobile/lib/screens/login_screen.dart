import 'package:flutter/material.dart';
import 'package:oust/helpers/hele_http_service.dart';
import 'package:oust/responses/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<StatefulWidget> {
  int _state = 0;
  String _error;
  String _phone;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _loginAsync() async {
    setState(() { _state = 1; _error = null; });
    try {
      var response = await heleHttpService.call<LoginResponse>('login', body: {'phone': _phone, 'password': _password});
      setState(() { _state = 2; });
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
        if (e is UnauthorizedException) {
          setState(() { _state = 0; _error = "Wallah bro tu t'es gouré quelque part, réessaye"; });
        }
      } else {
        print("--- NETWORK OR CODE ERROR ---");
      }
      print(e.toString());
    }
  }

  Widget setupRegisterLink() {
    return GestureDetector(
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
    );
  }

  void onLoginButtonPressed() {
    if (_state != 0) {
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this._loginAsync();
    }
  }

  Widget setupLoginButton() {
    Widget child;
    if (_state == 0) {
      child = new Text(
        "CONNEXION",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      child = CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      child = Icon(Icons.check, color: Colors.white);
    }
    return new MaterialButton(
      child: child,
      onPressed: onLoginButtonPressed,
      elevation: 4.0,
      minWidth: double.infinity,
      height: 48.0,
      color: _state == 1 ? Colors.lightGreen[300] : Colors.lightGreen,
    );
  }

  Widget setupErrorMessage() {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Text(
        _error == null ? "" : _error,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
      )
    ); 
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
                  setupRegisterLink(),
                  TextFormField(
                    onSaved: (value) => this._phone = value,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'N° de téléphone'),
                    validator: (value) {
                      if (!matches(value, r'^[0|\+33][6-7][0-9]{8}$')) {
                        return 'Entrez un numéro de téléphone mobile valide.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (value) => this._password = value,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Veuillez entrer votre mot de passe.";
                      }
                      return null;
                    },
                  ),
                  setupErrorMessage(),
                  setupLoginButton()
                ],
              )
            )
          )
        )
    );
  }
}

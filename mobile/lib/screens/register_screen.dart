import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oust/responses/register_response.dart';
import 'package:validators/validators.dart';
import 'package:oust/helpers/hele_http_service.dart';


class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegisterScreenState();
  }
}

class RegisterScreenState extends State<StatefulWidget> {
  String _phone;
  String _username;
  String _establishmentCode = "BDX";
  int _age;
  int _regionId = 2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _registerAsync() async {
    try {
      RegisterResponse res = await heleHttpService.call<RegisterResponse>('register', body: {
        'phone': this._phone,
        'username': this._username,
        'age': this._age.toString(),
        'region_id': this._regionId.toString(),
        'establishment_code': this._establishmentCode,
      });
      print("My password is ${res.password} <- wallaaaah");
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
        title: Text('RegisterScreen'),
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
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Vous avez déjà un compte ? ",
                        children: <TextSpan>[
                          TextSpan(text: 'Connectez-vous', style: TextStyle(
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
                    decoration: InputDecoration(labelText: 'N° de téléphone'),
                    validator: (value) {
                      if (!matches(value, r'^[0|\+33][6-7][0-9]{8}$')) {
                        return 'Entrez un numéro de téléphone mobile valide.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (value) => this._username = value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Pseudonyme (public)'),
                    validator: (value) {
                      if (!matches(value, r'^[a-zA-Z0-9-_]{3,20}$')) {
                        return "Entrez un pseudonyme allant de 3 à 20 caractères (sans espace).";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (value) => this._establishmentCode = value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Code établissement'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Veuillez entrer un code d'établissement.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (value) => this._age = int.parse(value),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Âge'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Veuillez entrer votre âge.";
                      }
                      int v = int.parse(value);
                      if (v < 10 || v > 99) {
                        return "Entrez votre âge.";
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text("S'INSCRIRE"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        this._registerAsync();
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

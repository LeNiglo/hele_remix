import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void _registerAsync() {
    http.post('http://localhost:3333/v1/auth/register', body: {
      'phone': this._phone,
      'username': this._username,
      'age': this._age.toString(),
      'region_id': this._regionId.toString(),
      'establishment_code': this._establishmentCode,
    }).then((response) async {
      print(response.body);
      var res = jsonDecode(response.body);
      if (res.status != null && int.parse(res.status) > 399) {
        throw "HttpError";
      }
      Navigator.pushReplacementNamed(context, '/');
    }).catchError((response) => print(response) );
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
                  TextFormField(
                    onSaved: (value) => this._phone = value,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                  TextFormField(
                    onSaved: (value) => this._username = value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextFormField(
                    onSaved: (value) => this._establishmentCode = value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Establishment Code'),
                  ),
                  TextFormField(
                    onSaved: (value) => this._age = int.parse(value),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Age'),
                  ),
                  RaisedButton(
                    child: Text('Register'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        this._registerAsync();
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

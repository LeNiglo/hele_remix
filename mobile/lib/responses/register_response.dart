import 'package:flutter/foundation.dart';
import 'package:oust/models/user.dart';

class RegisterResponse {
  final User user;
  final String password;

  RegisterResponse({
    @required this.user,
    @required this.password,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: User.fromJson(json['user']),
      password: json['access_token'],
    );
  }
}
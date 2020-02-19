import 'package:flutter/foundation.dart';
import 'package:oust/models/access_token.dart';
import 'package:oust/models/user.dart';

class LoginResponse {
  final User user;
  final AccessToken accessToken;

  LoginResponse({
    @required this.user,
    @required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      accessToken: AccessToken.fromJson(json['access_token']),
    );
  }
}
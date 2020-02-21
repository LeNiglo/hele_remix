import 'package:flutter/foundation.dart';

class AccessToken {
  final String type;
  final String token;
  final String refreshToken;

  AccessToken({
    @required this.type,
    @required this.token,
    @required this.refreshToken,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      type: json['type'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
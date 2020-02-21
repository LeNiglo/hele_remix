import 'package:flutter/foundation.dart';

class User {
  final int id;
  final bool isActive;
  final int birthYear;
  final int regionId;
  final String username;
  final String phone;
  final String phonePro;
  final String email;
  final String role;
  final String profession;
  final String city;
  final DateTime lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    @required this.id,
    @required this.isActive,
    @required this.birthYear,
    @required this.regionId,
    @required this.username,
    @required this.phone,
    @required this.phonePro,
    @required this.email,
    @required this.role,
    @required this.profession,
    @required this.city,
    @required this.lastLogin,
    @required this.createdAt,
    @required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      isActive: json['isActive'] as bool,
      birthYear: json['birthYear'] as int,
      regionId: json['regionId'] as int,
      username: json['username'] as String,
      phone: json['phone'] as String,
      phonePro: json['phonePro'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      profession: json['profession'] as String,
      city: json['city'] as String,
      lastLogin: json['lastLogin'] as DateTime,
      createdAt: json['createdAt'] as DateTime,
      updatedAt: json['updatedAt'] as DateTime,
    );
  }
}
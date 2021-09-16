import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    @required this.name,
    @required this.email,
    @required this.phone,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'password': user.password,
    };
  }
}

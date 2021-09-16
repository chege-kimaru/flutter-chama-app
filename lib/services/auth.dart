import 'dart:convert';

import 'package:chama_app/models/user.dart';
import 'package:chama_app/utils/api-error-handler.dart';
import 'package:chama_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  Future<User> register(User user) async {
    try {
      final url = "$BASE_URL/auth/register";
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(User.toJson(user)));
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        User registeredUser = User.fromJson(responseData);
        print(registeredUser);
        return registeredUser;
      } else {
        throw apiErrorHandler('Registration failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

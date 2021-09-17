import 'dart:convert';

import 'package:chama_app/models/user.dart';
import 'package:chama_app/utils/api-error-handler.dart';
import 'package:chama_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class VerifyPhoneDto {
  final String phone;
  final int code;

  VerifyPhoneDto({@required this.phone, @required this.code});

  static Map<String, dynamic> toJson(VerifyPhoneDto dto) {
    return {
      'phone': dto.phone,
      'code': dto.code,
    };
  }
}

class Auth extends ChangeNotifier {
  String phoneToVerify;

  Future<User> register(User user) async {
    try {
      final url = "$BASE_URL/auth/register";
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(User.toJson(user)));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // set the phone to verify state
        this.phoneToVerify = user.phone;
        notifyListeners();
        return User.fromJson(responseData);
      } else {
        throw apiErrorHandler('Registration failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> verifyPhone(VerifyPhoneDto dto) async {
    try {
      final url = "$BASE_URL/auth/verify";
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(VerifyPhoneDto.toJson(dto)));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
      } else {
        throw apiErrorHandler('Verification failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> resendVerificationCode(String phone) async {
    try {
      final url = "$BASE_URL/auth/verify/resend";
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({'phone': phone}));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
      } else {
        throw apiErrorHandler('Verification failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

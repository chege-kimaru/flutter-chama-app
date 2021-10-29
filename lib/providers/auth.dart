import 'dart:convert';

import 'package:chama_app/models/user.dart';
import 'package:chama_app/utils/api-error-handler.dart';
import 'package:chama_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhoneCodeDto {
  final String phone;
  final int code;

  PhoneCodeDto({@required required this.phone, @required required this.code});

  static Map<String, dynamic> toJson(PhoneCodeDto dto) {
    return {
      'phone': dto.phone,
      'code': dto.code,
    };
  }
}

class LoginDto {
  final String phone;
  final String password;

  LoginDto({@required required this.phone, @required required this.password});

  static Map<String, dynamic> toJson(LoginDto dto) {
    return {
      'phone': dto.phone,
      'password': dto.password,
    };
  }
}

class ResetPassDto {
  final String phone;
  final int code;
  final String password;

  ResetPassDto(
      {@required required this.phone,
      @required required this.code,
      @required required this.password});

  static Map<String, dynamic> toJson(ResetPassDto dto) {
    return {
      'phone': dto.phone,
      'code': dto.code,
      'password': dto.password,
    };
  }
}

class Auth extends ChangeNotifier {
  String? phoneToVerify;

  User? _user;
  String? _token;

  get user {
    return this._user;
  }

  get token {
    return this._token;
  }

  bool get isAuth {
    return _token != null && _user != null;
  }

  Future<bool> tryAutoLogin() async {
    print('=============try autologin');

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('user') || !prefs.containsKey('token')) return false;

    this._user = User.fromJson(json.decode(prefs.getString('user') ?? '{}'));
    this._token = prefs.getString('token');

    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    try {
      this._user = null;
      this._token = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('user');
      prefs.remove('token');
      // prefs.clear();
      notifyListeners();
    } catch (error) {
      print('LOGGING OUT');
      print(error);
      throw error;
    }
  }

  Future<User> login(LoginDto loginDto) async {
    try {
      final url = Uri.parse("$BASE_URL/auth/login");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(LoginDto.toJson(loginDto)));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
        // save token
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', json.encode(responseData['user']));
        prefs.setString('token', responseData['jwt'] as String);
        this._user = User.fromJson(responseData['user']);
        this._token = responseData['jwt'] as String;
        notifyListeners();
        return User.fromJson(responseData['user']);
      } else {
        throw apiErrorHandler('Login failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<User> register(User user) async {
    try {
      final url = Uri.parse("$BASE_URL/auth/register");
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

  Future<void> verifyPhone(PhoneCodeDto dto) async {
    try {
      final url = Uri.parse("$BASE_URL/auth/verify");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(PhoneCodeDto.toJson(dto)));
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
      final url = Uri.parse("$BASE_URL/auth/verify/resend");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({'phone': phone}));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
      } else {
        throw apiErrorHandler('Resend failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> forgotPass(String phone) async {
    try {
      final url = Uri.parse("$BASE_URL/auth/request-change-password");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({'phone': phone}));
      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
      } else {
        throw apiErrorHandler('Failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> resetPass(ResetPassDto dto) async {
    try {
      final url = Uri.parse("$BASE_URL/auth/change-password");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(ResetPassDto.toJson(dto)));
      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
      } else {
        throw apiErrorHandler('Failed', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

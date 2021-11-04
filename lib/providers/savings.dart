import 'package:chama_app/models/group.dart';
import 'package:chama_app/models/saving.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:chama_app/utils/api-error-handler.dart';
import 'package:chama_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Savings extends ChangeNotifier {
  final String? authToken;
  final String? currentGroupId;
  final Group? currentGroup;

  Savings({this.authToken, this.currentGroupId, this.currentGroup});

  List<Saving> _userGroupSavings = [];

  List<Saving> _allGroupSavings = [];

  double _totalUserGroupSavings = 0;

  double _totalGroupSavings = 0;

  List<Saving> get userGroupSavings {
    return [..._userGroupSavings];
  }

  List<Saving> get allGroupSavings {
    return [..._allGroupSavings];
  }

  double get totalUserGroupSavings {
    return _totalUserGroupSavings;
  }

  double get totalGroupSavings {
    return _totalGroupSavings;
  }

  Future<void> addSaving(int amount) async {
    try {
      final url = Uri.parse("$BASE_URL/groups/${this.currentGroupId}/savings");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${this.authToken}'
          },
          body: json.encode({'amount': amount}));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw apiErrorHandler(
            'Could not initialize payment', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getUserGroupSavings() async {
    print('===================retrieving user savings');
    print(this.currentGroup);
    print(this.currentGroupId);
    try {
      final url =
          Uri.parse("$BASE_URL/groups/${this.currentGroupId}/savings/user");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> rawSavings = List.from(responseData);
        List<Saving> savings = [];
        for (dynamic saving in rawSavings) {
          savings.add(Saving.fromJson(saving));
        }
        this._userGroupSavings = savings;
        notifyListeners();
      } else {
        throw apiErrorHandler('Could not load your savings in this group',
            responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getTotalUserGroupSavings() async {
    try {
      final url = Uri.parse(
          "$BASE_URL/groups/${this.currentGroupId}/savings/user/total");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        this._totalUserGroupSavings = double.parse(responseData['total']);
        notifyListeners();
      } else {
        throw apiErrorHandler('Could not load your total savings in this group',
            responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getAllGroupSavings() async {
    try {
      final url = Uri.parse("$BASE_URL/groups/${this.currentGroupId}/savings");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> rawSavings = List.from(responseData);
        List<Saving> savings = [];
        for (dynamic saving in rawSavings) {
          savings.add(Saving.fromJson(saving));
        }
        this._allGroupSavings = savings;
        notifyListeners();
      } else {
        throw apiErrorHandler(
            'Could not load this group\'s savings.', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getTotalGroupSavings() async {
    try {
      final url =
          Uri.parse("$BASE_URL/groups/${this.currentGroupId}/savings/total");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        this._totalGroupSavings = double.parse(responseData['total']);
        print('total savings $_totalGroupSavings');
        notifyListeners();
      } else {
        throw apiErrorHandler('Could not load your total savings in this group',
            responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

import 'package:chama_app/models/group.dart';
import 'package:chama_app/models/loan.dart';
import 'package:chama_app/models/saving.dart';
import 'package:chama_app/utils/api-error-handler.dart';
import 'package:chama_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loans extends ChangeNotifier {
  final String? authToken;
  final String? currentGroupId;
  final Group? currentGroup;

  Loans({this.authToken, this.currentGroupId, this.currentGroup});

  List<Loan> _userGroupLoans = [];

  List<Loan> _allGroupLoans = [];

  List<Loan> get userGroupLoans {
    return [..._userGroupLoans];
  }

  List<Loan> get allGroupLoans {
    return [..._allGroupLoans];
  }

  Future<void> requestLoan(int loanProductId) async {
    try {
      final url =
          Uri.parse("$BASE_URL/groups/${this.currentGroupId}/loans/request");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${this.authToken}'
          },
          body: json.encode({'loanProductId': loanProductId}));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw apiErrorHandler(
            'Loan request could not go through', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> payLoan(double amount, String loanId) async {
    try {
      final url = Uri.parse(
          "$BASE_URL/groups/${this.currentGroupId}/loans/$loanId/pay");
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

  Future<void> getUserGroupLoans() async {
    print('===================retrieving user loans');
    print(this.currentGroup);
    print(this.currentGroupId);
    try {
      final url =
          Uri.parse("$BASE_URL/groups/${this.currentGroupId}/loans/user");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> rawLoans = List.from(responseData);
        List<Loan> loans = [];
        for (dynamic loan in rawLoans) {
          loans.add(Loan.fromJson(loan));
        }
        this._userGroupLoans = loans;
        notifyListeners();
      } else {
        throw apiErrorHandler(
            'Could not load your loans in this group', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getAllGroupLoans() async {
    try {
      final url = Uri.parse("$BASE_URL/groups/${this.currentGroupId}/loans");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> rawLoans = List.from(responseData);
        List<Loan> loans = [];
        for (dynamic loan in rawLoans) {
          loans.add(Loan.fromJson(loan));
        }
        this._allGroupLoans = loans;
        notifyListeners();
      } else {
        throw apiErrorHandler(
            'Could not load this group\'s loans.', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

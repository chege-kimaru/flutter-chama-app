import 'dart:convert';

import 'package:chama_app/models/group-member.dart';
import 'package:chama_app/models/group.dart';
import 'package:chama_app/utils/api-error-handler.dart';
import 'package:chama_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupDto {
  final String name;

  CreateGroupDto(this.name);

  static Map<String, dynamic> toJson(CreateGroupDto dto) {
    return {
      'name': dto.name,
    };
  }
}

class CurrentGroupProvider extends ChangeNotifier {
  final String? authToken;

  CurrentGroupProvider({this.authToken});

  Group? _currentGroup;

  get currentGroup {
    return _currentGroup;
  }

  setCurrentGroup(Group? group) async {
    print('============================in setCurrentGroup');

    this._currentGroup = group;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('group', json.encode(Group.toJson(_currentGroup!)));

    print('==========Group ${prefs.getString('group')}');

    notifyListeners();
  }

  Future<bool> tryAutoSetCurrentGroup() async {
    print('============================in tryAutoSetCurrentGroup');

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('group')) return false;

    print(
        '============================in tryAutoSetCurrentGroup: not returning false');

    print(prefs.getString('group'));
    print(json.decode(prefs.getString('group') ?? '{}'));
    print(Group.fromJson(json.decode(prefs.getString('group') ?? '{}')));

    _currentGroup =
        Group.fromJson(json.decode(prefs.getString('group') ?? '{}'));

    print('AFter setting current group');

    notifyListeners();

    print(_currentGroup);

    // fetch latest group details from server
    // getGroupDetails().then((group) {
    //   setCurrentGroup(group);
    // });

    return true;
  }

  Future<Group> getGroupDetails() async {
    try {
      final url = Uri.parse("$BASE_URL/groups/${this.currentGroup!.id!}");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Group.fromJson(responseData);
      } else {
        throw apiErrorHandler(
            'Could not load group details', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

class Groups extends ChangeNotifier {
  final String? authToken;
  final Group? currentGroup;

  Groups({this.authToken, this.currentGroup});

  List<GroupMember> _userGroupMemberships = [];

  List<GroupMember> _verifiedGroupMemberships = [];
  List<GroupMember> _unverifiedGroupMemberships = [];

  List<GroupMember> get userGroupMemberships {
    return [..._userGroupMemberships];
  }

  List<GroupMember> get verifiedGroupMemberships {
    return [..._verifiedGroupMemberships];
  }

  List<GroupMember> get unverifiedGroupMemberships {
    return [..._unverifiedGroupMemberships];
  }

  // setCurrentGroup(Group? group) async {
  //   print('============================in setCurrentGroup');

  //   this.currentGroup = group;

  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('group', json.encode(currentGroup));

  //   notifyListeners();
  // }

  // Future<bool> tryAutoSetCurrentGroup() async {
  //   print('============================in tryAutoSetCurrentGroup');

  //   final prefs = await SharedPreferences.getInstance();

  //   if (!prefs.containsKey('group')) return false;

  //   print(
  //       '============================in tryAutoSetCurrentGroup: not returning false');

  //   this.currentGroup =
  //       Group.fromJson(json.decode(prefs.getString('group') ?? '{}'));

  //   // fetch latest group details from server
  //   getGroupDetails(this.currentGroup!.id!).then((group) {
  //     setCurrentGroup(group);
  //   });

  //   notifyListeners();

  //   return true;
  // }

  Future<Group> createGroup(CreateGroupDto dto) async {
    try {
      final url = Uri.parse("$BASE_URL/groups");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${this.authToken}'
          },
          body: json.encode(CreateGroupDto.toJson(dto)));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Group.fromJson(responseData);
      } else {
        throw apiErrorHandler(
            'Could not create group', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // Future<Group> getGroupDetails(String groupId) async {
  //   try {
  //     final url = Uri.parse("$BASE_URL/groups/$groupId");
  //     final response = await http.get(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer ${this.authToken}'
  //       },
  //     );
  //     final responseData = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return Group.fromJson(responseData);
  //     } else {
  //       throw apiErrorHandler(
  //           'Could not load group details', responseData['message']);
  //     }
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  Future<void> getUserGroups() async {
    try {
      final url = Uri.parse("$BASE_URL/groups/user");
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> rawUserGroupMemberships = List.from(responseData);
        List<GroupMember> userGroupMemberships = [];
        for (dynamic membership in rawUserGroupMemberships) {
          userGroupMemberships.add(GroupMember.fromJson(membership));
        }
        this._userGroupMemberships = userGroupMemberships;
        notifyListeners();
      } else {
        throw apiErrorHandler(
            'Could not load your groups', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Group> findGroupByCode(int code) async {
    try {
      final url = Uri.parse("$BASE_URL/groups")
          .replace(queryParameters: {'code': '$code'});
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> groups = List.from(responseData);

        if (groups.length == 0) {
          throw Exception('There is no group with this code.');
        }

        return Group.fromJson(groups[0]);
      } else {
        throw apiErrorHandler(
            'Could not get group with this code', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      final url = Uri.parse("$BASE_URL/groups/$groupId/members");
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        throw apiErrorHandler('Could not join group', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> verifyGroupMember(String userId, bool verified) async {
    try {
      final url = Uri.parse(
          "$BASE_URL/groups/${currentGroup?.id}/members/$userId/verify");
      final response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${this.authToken}'
          },
          body: json.encode({'verified': verified}));
      final responseData = json.decode(response.body);
      // print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        throw apiErrorHandler(
            'Could not verfiy group', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<GroupMember>> getGroupMembers(bool verified) async {
    try {
      print('CURRENT GROUP');
      print(currentGroup);
      final url = Uri.parse("$BASE_URL/groups/${currentGroup!.id}/members")
          .replace(queryParameters: {'verified': verified ? 'true' : 'false'});
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${this.authToken}'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> rawGroupMemberships = List.from(responseData);
        print(rawGroupMemberships);
        List<GroupMember> groupMemberships = [];
        for (dynamic membership in rawGroupMemberships) {
          print('MEMBERSHIP');
          print(membership);
          groupMemberships.add(GroupMember.fromJson(membership));
        }
        return groupMemberships;
      } else {
        throw apiErrorHandler(
            'Error loading group members', responseData['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getVerifiedGroupMembers() async {
    try {
      this._verifiedGroupMemberships = await this.getGroupMembers(true);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUnVerifiedGroupMembers() async {
    try {
      this._unverifiedGroupMemberships = await this.getGroupMembers(false);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

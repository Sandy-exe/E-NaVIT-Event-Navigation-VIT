import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:enavit/models/og_models.dart';

class ApproverSearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late List<Users> userListObj = [];
  
  late List<Users> userListApprover = [];
  
  List<Users> _suggestions = history;
  List<Users> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  Future<void> initUserList(List<Users> userList) async {
    Future<void> initPrefs() async {
      userListObj = userList;
      userListApprover = userList;
      print(userListObj.length);
    }

    await initPrefs();
    notifyListeners();
  }

  Future<void> onQueryChanged(String query) async {
    if (query == _query) {
      return;
    }

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = history;
    } else {
      _suggestions = userListObj.where((element) => element.name.toLowerCase().startsWith(query.toLowerCase())).take(2).toList() + userListObj.where((element) => element.regNo.toLowerCase().startsWith(query.toLowerCase())).take(2).toList();
      print(_suggestions);

    }
    _isLoading = false;
    notifyListeners();
  }

  void clear(Users newValue) {
    if (history.length > 2) {
      history.removeLast();
    }

    history.insert(0, newValue);

    userListApprover = [newValue];

    _suggestions = history;
    notifyListeners();
  }
}

List<Users> history = [];

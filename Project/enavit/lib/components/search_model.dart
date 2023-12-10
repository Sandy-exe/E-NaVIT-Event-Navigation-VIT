
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:enavit/models/og_models.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late List<Event> eventListObj = [];
  //to display in home page
  late List<Event> eventListHome = [];
  List<Event> _suggestions = history;
  List<Event> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  Future<void> initEventList(List<Event> eventList) async {
    Future<void> initPrefs() async {
      eventListObj = eventList;
      eventListHome = eventList;
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
      _suggestions = eventListObj.where((element) => element.eventName.toLowerCase().startsWith(query.toLowerCase())).toList();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear(Event newValue) {
    history.insert(0, newValue);
    if (history.length > 3) {
      history.removeLast();
    }
    eventListHome = [newValue];
    _suggestions = history;

    notifyListeners();
  }
}

List<Event> history = [];



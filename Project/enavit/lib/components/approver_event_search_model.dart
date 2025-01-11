import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:enavit/models/og_models.dart';

class ApproverEventSearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late List<Event> eventListObj = [];
  late List<Event> eventListfinal = [];

  List<Event> _suggestions = history;
  List<Event> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  Future<void> initeventList(List<Event> eventList) async {
    Future<void> initPrefs() async {
      eventListObj = eventList;
      eventListfinal = eventList;
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
      _suggestions = eventListObj
          .where((element) =>
              element.eventName.toLowerCase().startsWith(query.toLowerCase()))
          .take(2)
          .toList();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear(Event newValue) {
    if (history.length > 2) {
      history.removeLast();
    }

    history.insert(0, newValue);

    eventListfinal = [newValue];

    _suggestions = history;
    notifyListeners();
  }
}

List<Event> history = [];

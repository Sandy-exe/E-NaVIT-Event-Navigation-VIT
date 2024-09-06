import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:enavit_main/models/og_models.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late List<Event> eventListObj = [];
  //to display in home page
  late List<Object> eventClubListHome = [];
  late List<Club> clubListObj = [];
  late List<Object> eventClubList = [];
  late List<Event> historyEvent = [];
  late List<Club> historyClub = [];
  List<Object> _suggestions = history;
  List<Object> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  Future<void> initEventClubList(
      List<Event> eventList, List<Club> clubList) async {
    Future<void> initPrefs() async {
      eventListObj = eventList;
      clubListObj = clubList;

      eventClubList = [...eventListObj, ...clubListObj];
      eventClubListHome = [...eventListObj, ...clubListObj];
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
      _suggestions = [
        ...eventListObj
            .where((element) =>
                element.eventName.toLowerCase().startsWith(query.toLowerCase()))
            .take(2),
        ...clubListObj
            .where((element) =>
                element.clubName.toLowerCase().startsWith(query.toLowerCase()))
            .take(2)
      ];
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear(Object newValue) {
    if (newValue is Club) historyClub.insert(0, newValue);
    if (newValue is Event) historyEvent.insert(0, newValue);

    if (historyClub.length > 2) {
      historyClub.removeLast();
    }

    if (historyEvent.length > 2) {
      historyEvent.removeLast();
    }

    history = [...historyEvent, ...historyClub];

    eventClubListHome = [newValue];

    _suggestions = history;

    notifyListeners();
  }
}

List<Object> history = [];

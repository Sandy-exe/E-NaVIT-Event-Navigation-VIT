import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:enavit/models/og_models.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _suggestions = history;
  List<String> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

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
      _suggestions = eventList.where((element) => element.startsWith(query)).toList();
      print(_suggestions);
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = history;
    notifyListeners();
  }
}

const List<String> history = <String>[
  "Item 4",
  "Item 5",
];

const List<String> eventList = <String>[
  "Item 1",
  "Item 2",
  "Item 3",
];

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:enavit/Data/secure_storage.dart';

class Compute with ChangeNotifier {
  //for datepicker widget
  final refWeeklist = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final refMonthlist = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late List<String> dayList = [];
  late List<String> monthList = [];
  late List<String> weekList = [];
  late int selected = 3;
  late List<dynamic> preDayList = [];
  late List<String> yearList = [];
  SecureStorage secureStorage = SecureStorage();
  List<Map<String, dynamic>> events = [];
  String eventsString = "";
  int eventExist = 0;
  String updateFilter = "Week";

  //MAIN IMPORTING widgets
  late List<String> datePickerUpper = [];
  late List<String> datePickerLower = [];
  late List<Map<String, dynamic>> timeLineEvents = [];

  Future<void> saveEventsWeek() async {
    events = [];

    eventExist = 0; //to check whether events exist or not for specific date

    if (eventsString == "") eventsString = (await secureStorage.reader(key: "events")) ?? "null";

    if (eventsString == "null") return;

    List<String> userEvent = eventsString.split("JOIN");

    events.add({
      "name": "",
      "startTime": "23:59",
      "endTime": "23:59",
      "isLast": "false",
      "toDisplay": "23:59"
    });
    events.add({
      "name": "",
      "startTime": "00:00",
      "endTime": "00:00",
      "isLast": "false",
      "toDisplay": "00:00"
    });

    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);
      // print(event);
      if (eventData["dateTime"]["startTime"].substring(0, 10) !=
          preDayList[selected].toString().substring(0, 10)) continue;
      eventExist = 1; //to check whether events exist or not for specific date

      Map<String, dynamic> tempData = {
        "name": eventData["eventName"],
        "startTime": eventData["dateTime"]["startTime"].substring(11, 16),
        "endTime": eventData["dateTime"]["endTime"].substring(11, 16),
        "isLast": "false",
        "toDisplay": eventData["dateTime"]["startTime"].substring(11, 16)
      };
      events.add(tempData);
    }

    events.sort((a, b) => a['startTime'].compareTo(b['startTime']));

    for (int e = 2; e < events.length - 1; e++) {
      if (events[e - 1]["name"] != "" &&
          events[e]["name"] != "" &&
          ((int.parse(events[e]["startTime"].substring(0, 2))) -
                  (int.parse(events[e - 1]["startTime"].substring(0, 2)))) !=
              1) {
        int toDisplay = (int.parse(events[e]["startTime"].substring(0, 2))) - 1;
        events.add({
          "name": "",
          "startTime": toDisplay.toString(),
          "endTime": "",
          "isLast": "false",
          "toDisplay": toDisplay.toString()
        });
      }
    }

    events.add({
      "name": "",
      "startTime": "End of Day",
      "endTime": "",
      "isLast": "true",
      "toDisplay": "End of Day"
    });

    timeLineEvents = events;
  }

  void datePickerWeek(int selectedIndex) {
    Future.delayed(Duration.zero, () async {
      var today = DateTime.now();
      preDayList = List<DateTime>.generate(7, (index) {
        return today.add(Duration(days: index - 3));
      });
      dayList = preDayList.map((e) => e.day.toString()).toList();

      weekList = List<String>.generate(7, (index) {
        return refWeeklist[preDayList[index].weekday - 1];
      });

      //importing values to datepicker widget
      datePickerLower = dayList;
      datePickerUpper = weekList;
      selected = selectedIndex;
      updateFilter = "Week";

      await saveEventsWeek();

      notifyListeners();
    });
  }

  Future<void> saveEventsMonth() async {
    events = [];

    eventExist = 0; //to check whether events exist or not for specific date

    if (eventsString == "") eventsString = (await secureStorage.reader(key: "events")) ?? "null";

    if (eventsString == "null") return;

    List<String> userEvent = eventsString.split("JOIN");

    events.add({
      "name": "",
      "startTime": "23:59",
      "endTime": "23:59",
      "isLast": "false",
      "date": "1000-01-01",
      "toDisplay": "Beginning of Month"
    });
    events.add({
      "name": "",
      "startTime": "00:00",
      "endTime": "00:00",
      "isLast": "true",
      "date": "3001-12-12",
      "toDisplay": "End of Month"
    });

    String lastEventDate = "1800-01-01";

    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);
      // print(event);
      int incremented = selected + 1;
      if (eventData["dateTime"]["startTime"].substring(5, 7) !=
          (incremented.toString().length < 2
              ? "0$incremented"
              : incremented.toString())) continue;
      eventExist = 1; //to check whether events exist or not for specific date

      Map<String, dynamic> tempData = {
        "name": eventData["eventName"],
        "startTime": eventData["dateTime"]["startTime"].substring(11, 16),
        "endTime": eventData["dateTime"]["endTime"].substring(11, 16),
        "date": eventData["dateTime"]["startTime"].substring(0, 10),
        "isLast": "false",
        "toDisplay": eventData["dateTime"]["startTime"].substring(8, 10)
      };

      lastEventDate = eventData["dateTime"]["startTime"].substring(0, 10);
      events.add(tempData);
    }

    String lastDate = DateTime(DateTime.parse(lastEventDate).year,
            DateTime.parse(lastEventDate).month + 1, 1)
        .subtract(const Duration(days: 1))
        .toString()
        .substring(0, 10);

    if (lastDate != lastEventDate) {
      events.add({
        "name": "",
        "startTime": "00:00",
        "endTime": "00:00",
        "isLast": "false",
        "date": lastDate,
        "toDisplay": lastDate.substring(8, 10),
      });
    }

    events.sort((a, b) =>
        DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

    timeLineEvents = events;
  }

  void datePickerMonth(int selectedIndex) {
    Future.delayed(Duration.zero, () async {
      var lowerMonth = List<String>.generate(12, (index) {
        return (index + 1).toString();
      });

      //importing values to datepicker widget
      datePickerLower = lowerMonth;
      datePickerUpper = refMonthlist;
      selected = selectedIndex;
      updateFilter = "Month";

      //await saveEventsWeek();
      await saveEventsMonth();

      notifyListeners();
    });
  }

  Future<void> saveEventsYear() async {
    events = [];
    eventExist = 0; //to check whether events exist or not for specific date

    if (eventsString == "") eventsString = (await secureStorage.reader(key: "events")) ?? "null";

    if (eventsString == "null") return;

    List<String> userEvent = eventsString.split("JOIN");

    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);
      // print(event);
      if (eventData["dateTime"]["startTime"].substring(0, 4) !=
          yearList[selected]) continue;
      eventExist = 1; //to check whether events exist or not for specific date

      Map<String, dynamic> tempData = {
        "name": eventData["eventName"],
        "startTime": eventData["dateTime"]["startTime"].substring(11, 16),
        "endTime": eventData["dateTime"]["endTime"].substring(11, 16),
        "mon": eventData["dateTime"]["startTime"].substring(5, 7),
        "isLast": "false",
        "toDisplay": refMonthlist[
            int.parse(eventData["dateTime"]["startTime"].substring(5, 7)) - 1]
      };

      events.add(tempData);
    }
    //events.sort((a, b) => a['mon'].compareTo(b['mon']));
    events.add({
      "name": "",
      "startTime": "00:00",
      "endTime": "00:00",
      "isLast": "true",
      "mon": "13",
      "toDisplay": "End of Year"
    });

    events.insert(0, {
      "name": "",
      "startTime": "23:59",
      "endTime": "23:59",
      "isLast": "false",
      "mon": "-1",
      "toDisplay": "Beginning of Year"
    });

    timeLineEvents = events;
  }

  void datePickerYear(int selectedIndex) {
    Future.delayed(Duration.zero, () async {
      int currentYear = DateTime.now().year;

      yearList = List<String>.generate(9, (index) {
        return (currentYear + index - 4).toString();
      });

      //importing values to datepicker widget
      datePickerLower = [
        "year",
        "year",
        "year",
        "year",
        "year",
        "year",
        "year",
        "year",
        "year"
      ];
      datePickerUpper = yearList;
      selected = selectedIndex;
      updateFilter = "Year";

      //await saveEventsWeek();
      await saveEventsYear();

      notifyListeners();
    });
  }

  Future<void> saveEventsHistory() async {
    events = [];
    eventExist = 0; //to check whether events exist or not for specific date

    if (eventsString == "") eventsString = (await secureStorage.reader(key: "events")) ?? "null";

    if (eventsString == "null") return;

    List<String> userEvent = eventsString.split("JOIN");


    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);

      Map<String, dynamic> tempData = {
        "name": eventData["eventName"],
        "startTime": eventData["dateTime"]["startTime"].substring(11, 16),
        "endTime": eventData["dateTime"]["endTime"].substring(11, 16),
        "mon": eventData["dateTime"]["startTime"].substring(5, 7),
        "isLast": "false",
        "toDisplay": ""
      };


      if (selected == 0) {
        if (DateTime.parse(eventData["dateTime"]["startTime"]).isBefore(DateTime.now())) {
          eventExist =1; //to check whether events exist or not for specific date
          events.add(tempData);
        }
      } else if (selected == 1) {
        if (DateTime.parse(eventData["dateTime"]["startTime"].toString()).isAtSameMomentAs(DateTime.now())) {
          eventExist =1; //to check whether events exist or not for specific date
          events.add(tempData);
        }
      } else if (selected == 2) {
        if (DateTime.parse(eventData["dateTime"]["startTime"]).isAfter(DateTime.now())) {
          eventExist =1; //to check whether events exist or not for specific date
          events.add(tempData);
        }
      }

    }
    events.sort((a, b) => a['mon'].compareTo(b['mon']));

    events.add({
      "name": "",
      "startTime": "00:00",
      "endTime": "00:00",
      "isLast": "true",
      "mon": "13",
      "toDisplay": "The End of Time"
    });

    events.insert(0, {
      "name": "",
      "startTime": "23:59",
      "endTime": "23:59",
      "isLast": "false",
      "mon": "-1",
      "toDisplay": "The Beginning of Time"
    });

    timeLineEvents = events;
  }

  void datePickerHistory(int selectedIndex) {
    Future.delayed(Duration.zero, () async {
      var history = ["Completed", "On Going", "Scheduled"];
      //importing values to datepicker widget
      datePickerLower = ["0", "1", "2"];
      datePickerUpper = history;
      selected = selectedIndex;
      updateFilter = "History";

      await saveEventsHistory();

      notifyListeners();
    });
  }
}

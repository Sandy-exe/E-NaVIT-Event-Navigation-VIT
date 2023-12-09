
import 'dart:convert';

import 'package:flutter/material.dart'; 
import 'package:flutter/foundation.dart';
import 'package:enavit/Data/secure_storage.dart';


class Compute with ChangeNotifier{

  //for datepicker widget
  final refWeeklist = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final refMonthlist = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct','Nov','Dec'];
  late List<String> dayList=[];
  late List<String> monthList=[];
  late List<String> weekList=[];
  late int selected=3;
  late List<dynamic> preDayList=[];
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
    events= [];

    eventExist = 0;//to check whether events exist or not for specific date

    if (eventsString == "") eventsString = (await secureStorage.reader(key: "events"))?? "null";

    if (eventsString == "null") return;
    
    List<String> userEvent = eventsString.split("JOIN");

    events.add({"name": "", "startTime": "23:59","endTime": "23:59", "isLast": "false"});
    events.add({"name":"","startTime":"00:00","endTime":"00:00","isLast":"false"});

    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);
      // print(event);
      if (eventData["dateTime"]["startTime"].substring(0, 10) != preDayList[selected].toString().substring(0,10)) continue;
      eventExist = 1; //to check whether events exist or not for specific date

      Map<String, dynamic> tempData = {
        "name": eventData["eventName"],
        "startTime": eventData["dateTime"]["startTime"].substring(11, 16),
        "endTime": eventData["dateTime"]["endTime"].substring(11, 16),
        "isLast": "false"
      }; 
      events.add(tempData);
    }


    events.sort((a, b) => a['startTime'].compareTo(b['startTime']));

    for (int e = 2; e < events.length - 1; e++) {
      if (events[e-1]["name"] != "" && events[e]["name"]!="" && ((int.parse(events[e]["startTime"].substring(0,2)))- (int.parse(events[e-1]["startTime"].substring(0,2)))) != 1) {
        events.add({"name": "", "startTime": ((int.parse(events[e]["startTime"].substring(0, 2)))-1).toString(),"endTime": "", "isLast": "false"});
      }
    }

    events.add({"name": "", "startTime": "End of Day","endTime":"", "isLast": "true"});

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
        return refWeeklist[preDayList[index].weekday-1];
      });

      //importing values to datepicker widget
      datePickerLower = dayList;
      datePickerUpper = weekList;
      selected = selectedIndex;
      updateFilter  = "Week";

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
      "isLast": "false"
    });
    events.add({
      "name": "",
      "startTime": "00:00",
      "endTime": "00:00",
      "isLast": "false"
    });

    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);
      // print(event);
      int incremented = selected + 1;
      if (eventData["dateTime"]["startTime"].substring(5, 7) != (incremented.toString().length < 2 ? "0$incremented" : incremented.toString())) continue;
      eventExist = 1; //to check whether events exist or not for specific date

      Map<String, dynamic> tempData = {
        "name": eventData["eventName"],
        "startTime": eventData["dateTime"]["startTime"].substring(11, 16),
        "endTime": eventData["dateTime"]["endTime"].substring(11, 16),
        "isLast": "false"
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
        events.add({
          "name": "",
          "startTime": ((int.parse(events[e]["startTime"].substring(0, 2))) - 1)
              .toString(),
          "endTime": "",
          "isLast": "false"
        });
      }
    }

    events.add({
      "name": "",
      "startTime": "End of Day",
      "endTime": "",
      "isLast": "true"
    });

    timeLineEvents = events;
    print(events);
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
      updateFilter  = "Month";

      //await saveEventsWeek();
      await saveEventsMonth();

      notifyListeners();
    });
  }

}
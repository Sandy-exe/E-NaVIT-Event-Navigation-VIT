
import 'package:flutter/material.dart'; 
import 'package:flutter/foundation.dart';

class Compute with ChangeNotifier{

  //for datepicker widget
  final refWeeklist = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  late List<String> dayList=[];
  late List<String> monthList=[];
  late List<String> weekList=[];
  late int selected=3;
  

  void datePicker(int selectedIndex) {
    Future.delayed(Duration.zero, () {
      var today = DateTime.now();
      var preDayList = List<DateTime>.generate(7, (index) {
        return today.add(Duration(days: index - 3));
      });
      dayList = preDayList.map((e) => e.day.toString()).toList();
      print(dayList);

      weekList = List<String>.generate(7, (index) {
        return refWeeklist[preDayList[index].weekday-1];
      });

      selected = selectedIndex;
      notifyListeners();
    });
  }

  
}
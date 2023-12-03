import 'package:flutter/material.dart';
import '../models/event.dart';

class AddEvent extends ChangeNotifier {
  List<Event> eventlist = [
    Event(
      id: 1,
      clubid: 1,
      name: "GOJO",
      description: "Daijobhu desu, tatakimi yowai mo!!",
      fee: "Very Expensive",
      venue: "Jujutsu High",
      date: DateTime.now(),
      imagePath: 'lib/images/GOJO.jpg',
    ),
    Event(
      id: 2,
      clubid: 2,
      name: "GOJO 2",
      description: "Daijobhu desu, tatakimi yowai mo!!",
      fee: "Limitless",
      venue: "Jujutsu High",
      date: DateTime.now(),
      imagePath: 'lib/images/GOJO.jpg',
    ),
    Event(
      id: 3,
      clubid: 2,
      name: "GOJO 3",
      description: "Daijobhu desu, tatakimi yowai mo!!",
      fee: "Limitless",
      venue: "Jujutsu High",
      date: DateTime.now(),
      imagePath: 'lib/images/GOJO.jpg',
    ),
  ];

  List<Event> userEventlist = [];

  List<Event> getEventList() {
    return eventlist;
  }

  List<Event> getUserEventList() {
    return userEventlist;
  }

  void addEventToUser(Event event) {
    userEventlist.add(event);
    notifyListeners();
  }

  void removeEventFromUser(Event event) {
    userEventlist.remove(event);
    notifyListeners();
  }

  String selectedEvent = "";

  


}

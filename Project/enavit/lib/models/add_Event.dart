import 'package:flutter/material.dart';
import '../models/event.dart';

class AddEvent extends ChangeNotifier {
  List<Event> eventlist = [
    Event(
      name: "GOJO",
      description: "Daijobhu desu, tatakimi yowai mo!!",
      fee: "Very Expensive",
      venue: "Jujutsu High",
      date: DateTime.now(),
      imagePath: "lib/images/GOJO.jpg",
    ),
    Event(
      name: "GOJO",
      description: "Daijobhu desu, tatakimi yowai mo!!",
      fee: "Limitless",
      venue: "Jujutsu High",
      date: DateTime.now(),
      imagePath: "lib/images/GOJO.jpg",
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
    print(userEventlist);
  }

  void removeEventFromUser(Event event) {
    print(userEventlist);
    userEventlist.remove(event);
    notifyListeners();
    print("removed?");
    print(userEventlist);
  }
}

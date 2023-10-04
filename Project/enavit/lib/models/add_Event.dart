import 'package:flutter/material.dart';
import 'event.dart';

class AddEvent extends ChangeNotifier{
  List<Event> Eventlist = [
    Event(
      name: "GOJO",
      description: "Daijobhu desu, tatakimi yowai mo!!",
      fee: "Limitless",
      venue: "Jujutsu High",
      date: DateTime.now(), 
      imagePath: "lib/images/GOJO.jpg",
    ),

    Event(
      name: "Shinobu",
      description: "Arah Arah!",
      fee: "Hotness",
      venue: "ButteryFly Mansion",
      date: DateTime.now(), 
      imagePath: "lib/images/butterfly.jpg",
    ),

  ];

  List<Event> UserEventlist = [];
  
  List<Event> getEventList() {
    return Eventlist;
  }

  List<Event> getUserEventList() {
    return UserEventlist;
  }

  void addEventToUser(Event event) {
    UserEventlist.add(event);
    notifyListeners();
  }

  void removeEventFromUser(Event event) {
    UserEventlist.remove(event);
  }


}
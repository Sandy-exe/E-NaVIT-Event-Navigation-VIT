import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/Data/secure_storage.dart';
// import 'package:enavit/services/authentication_service.dart';

class Services {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SecureStorage secureStorage = SecureStorage();

  Future<void> addUser(Users newUser) async {
    final docref = firestore.collection("app_users").doc(newUser.userId.toString());

    Map<String, dynamic> obj = {
      "userid": newUser.userId,
      "name": newUser.name,
      "email": newUser.email,
      "clubs": newUser.clubs,
      "events": newUser.events,
      "organized_events": newUser.organizedEvents,
      "role": newUser.role,
      "phone_no": newUser.phoneNo,
      "reg_no": newUser.regNo,
    };


    await docref.set(obj);//push the object
  }

  Future getUserData(String uid) async {
    final currentUser = await firestore.collection("app_users").doc(uid).get();

    Map<String, dynamic> currentUserData = currentUser.data()!;
    String currentUserDataString = jsonEncode(currentUserData);
    await secureStorage.writer(key: "currentUserData", value: currentUserDataString);
  }

  Future<List> getEventData() async {
    final querySnapshot = await firestore.collection("Events").get();
    List<Event> events = [];

    for (final docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();

      Map<String, DateTime> dateTime = {
        'startTime': (data['dateTime']['startTime'] as Timestamp).toDate(),
        'endTime': (data['dateTime']['endTime'] as Timestamp).toDate(),
      };
      
      events.add(
        Event(
          clubId: data['clubId'],
          dateTime: dateTime,
          description: data['description'],
          eventId: data['eventId'],
          eventName: data['eventName'],
          location: data['location'],
          fee: data['fee'],
          organisers: List<String>.from(data['organisers']),
          comments: Map<String, String>.from(data['comments']),
          participants: List<String>.from(data['participants']),
          likes: data['likes'],
        ),
      );
    }

    return events;

    // for (final docSnapshot in querySnapshot.docs) {
    //   Map<String, dynamic> docData = docSnapshot.data();
    //   String docDataString = jsonEncode(docData);
    //   await secureStorage.writer(key: "eventData", value: docDataString);
    // }
  }

  Future<void> updateUser (String uid, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await docref.update(newinfo);//push the object
  }

  Future<void> updateEvent (String eventId, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("Events").doc(eventId);
    await docref.update(newinfo);//push the object
  }





  //Creating Dummy Data
  // Future<void> createDummyData() async {
  //   // Create dummy data for clubs
  //   List<Club> clubs = [
  //     Club(
  //       clubId: "Club_1",
  //       clubName: "Dummy Club",
  //       bio: "Dummy Bio",
  //       email: "DummyEmail@dummy.com",
  //       events: ["Event_1", "Event_2"],
  //       approvers: ["Approver_1"],
  //     ),
  //     Club(
  //       clubId: "Club_2",
  //       clubName: "Dummy Club 2",
  //       bio: "Dummy Bio 2",
  //       email: "DummyEmail@dummy.com2",
  //       events: ["Event_3"],
  //       approvers: ["Approver_2"],
  //     ),
  //     Club(
  //       clubId: "Club_3",
  //       clubName: "Dummy Club 3",
  //       bio: "Dummy Bio 3",
  //       email: "DummyEmail@dummy.com3",
  //       events: [],
  //       approvers: ["Approver_3"],
  //     ),
  //     // Add more clubs here...
  //   ];

  //   // Write clubs to Firestore
  //   for (final club in clubs) {
  //     await firestore.collection('Clubs').doc(club.clubId).set({
  //       'clubName': club.clubName,
  //       'bio': club.bio,
  //       'email': club.email,
  //       'events': club.events,
  //       'approvers': club.approvers,
  //     });
  //   }

  //   // Create dummy data for events
  //   List<Event> events = [
  //     Event(
  //       clubId: "Club_1",
  //       dateTime: {
  //         "startTime": DateTime(2023, 12, 14, 17, 0),
  //         "endTime": DateTime(2023, 12, 14, 18, 0),
  //       },
  //       description: "This is a Dummy Event 1",
  //       eventId: "Event_1",
  //       eventName: "Dummy Event",
  //       location: "AB1 5th Floor",
  //       organisers: ["Dummy_org_1"],
  //       comments: {"userId": "Dummy Comment"},
  //       participants: ["dummyPart_ID"],
  //       likes: 300,
  //     ),
  //     Event(
  //       clubId: "Club_1",
  //       dateTime: {
  //         "startTime": DateTime(2023, 12, 13, 17, 0),
  //         "endTime": DateTime(2023, 12, 13, 18, 0),
  //       },
  //       description: "This is a Dummy Event 2",
  //       eventId: "Event_2",
  //       eventName: "Dummy Event",
  //       location: "AB1 5th Floor",
  //       organisers: ["Dummy_org_1"],
  //       comments: {"userId": "Dummy Comment"},
  //       participants: ["dummyPart_ID"],
  //       likes: 300,
  //     ),
  //     Event(
  //       clubId: "Club_2",
  //       dateTime: {
  //         "startTime": DateTime(2023, 12, 13, 16, 0),
  //         "endTime": DateTime(2023, 12, 13, 17, 0),
  //       },
  //       description: "This is a Dummy Event 3",
  //       eventId: "Event_3",
  //       eventName: "Dummy Event 3",
  //       location: "AB1 5th Floor",
  //       organisers: ["Dummy_org_1"],
  //       comments: {"userId": "Dummy Comment"},
  //       participants: ["dummyPart_ID"],
  //       likes: 300,
  //     ),
  //     // Add more events here...
  //   ];

  //   // Write events to Firestore
  //   for (final event in events) {
  //     await firestore.collection('Events').doc(event.eventId).set({
  //       'clubId': event.clubId,
  //       'dateTime': event.dateTime,
  //       'description': event.description,
  //       'eventName': event.eventName,
  //       'location': event.location,
  //       'organisers': event.organisers,
  //       'comments': event.comments,
  //       'participants': event.participants,
  //       'likes': event.likes,
  //     });
  //   }
  // }

  // Future<void> deleteTodoItem(String documentId) async {
  //   final DocumentReference documentReference =
  //       firestore.collection('tasks').doc(documentId);
  //   await documentReference.delete();
  // }










































































































































}

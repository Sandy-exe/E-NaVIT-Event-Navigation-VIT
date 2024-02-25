import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/components/approver_search_model.dart';
import 'package:enavit/components/approver_event_search_model.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/home_search_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:enavit/services/authentication_service.dart';

class Services {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SecureStorage secureStorage = SecureStorage();

  Future<void> addUser(Users newUser) async {
    final docref =
        firestore.collection("app_users").doc(newUser.userId.toString());

    Map<String, dynamic> obj = {
      "userid": newUser.userId,
      "name": newUser.name,
      "email": newUser.email,
      "clubs": newUser.clubs,
      "events": newUser.events,
      "organized_events": newUser.organizedEvents,
      "approval_events": newUser.approvalEvents,
      "role": newUser.role,
      "phone_no": newUser.phoneNo,
      "reg_no": newUser.regNo,
    };

    await docref.set(obj); //push the object
  }

  Future updateFcmToken(String uid) async {
    final userRef = firestore.collection("app_users").doc(uid);
    final user = await userRef.get();
    Map<String, dynamic> userData = user.data()!;
    //String fcmToken = List<String>.from(userData["fcmToken"]);
    //events.add(event.eventId);
    final _firebaseMessaging = FirebaseMessaging.instance;
    final fCMToken = await _firebaseMessaging.getToken();
    await userRef.update({"fcmToken": fCMToken});
  }

  Future getUserData(String uid) async {
    final currentUser = await firestore.collection("app_users").doc(uid).get();

    Map<String, dynamic> currentUserData = currentUser.data()!;
    String currentUserDataString = jsonEncode(currentUserData);
    await secureStorage.writer(
        key: "currentUserData", value: currentUserDataString);
    final userRole = currentUserData['role'];
    await secureStorage.writer(key: "userRole", value: userRole.toString());

    //Store Event data of the user
    List<String> events = [];
    List<Event> eventListObj = [];

    for (final eventId in currentUserData['events']) {
      final event = await firestore.collection("Events").doc(eventId).get();

      Map<String, dynamic> eventData = event.data()!;

      Map<String, String> dateTime = {
        'startTime': (eventData['dateTime']['startTime'] as Timestamp)
            .toDate()
            .toString(),
        'endTime':
            (eventData['dateTime']['endTime'] as Timestamp).toDate().toString(),
      };
      Map<String, dynamic> eventObj = {
        "clubId": eventData['clubId'],
        "dateTime": dateTime,
        "description": eventData['description'],
        "eventId": eventData['eventId'],
        "eventName": eventData['eventName'],
        "location": eventData['location'],
        "fee": eventData['fee'],
        "organisers": List<String>.from(eventData['organisers']),
        "comments": Map<String, String>.from(eventData['comments']),
        "participants": List<String>.from(eventData['participants']),
        "likes": eventData['likes'],
      };

      eventListObj.add(
        Event(
          clubId: eventData['clubId'],
          dateTime: eventData['dateTime'],
          description: eventData['description'],
          eventId: eventData['eventId'],
          eventName: eventData['eventName'],
          location: eventData['location'],
          fee: eventData['fee'],
          organisers: List<String>.from(eventData['organisers']),
          comments: Map<String, String>.from(eventData['comments']),
          participants: List<String>.from(eventData['participants']),
          likes: eventData['likes'],
          eventImageURL: eventData['eventImageURL'] ?? "null",
          discussionPoints: eventData['discussionPoints'] ?? "old doc",
          eventType: eventData['eventType'] ?? "old doc",
          eventCategory: eventData['eventCategory'] ?? "old doc",
          fdpProposedBy: eventData['fdpProposedBy'] ?? "old doc",
          schoolCentre: eventData['schoolCentre'] ?? "old doc",
          coordinator1: eventData['coordinator1'] ?? "old doc",
          coordinator2: eventData['coordinator2'] ?? "old doc",
          coordinator3: eventData['coordinator3'] ?? "old doc",
          expense: eventData['expense'] ?? "0",
          revenue: eventData['revenue'] ?? "0",
          budget: eventData['budget'] ?? "0",
          attendancePresent: eventData['attendancePresent'] ?? "0",
          issues: Map<String, Map<String, String>>.from(eventData['issues']),
          expectedRevenue: eventData['expectedRevenue'] ?? "0",
        ),
      );

      String eventDataString = jsonEncode(eventObj);
      events.add(eventDataString);
    }

    String eventsString = events.join("JOIN");
    await secureStorage.writer(key: "events", value: eventsString);
  }

  //details of all clubs and events
  Future<void> getEventClubData(BuildContext context) async {
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
          eventImageURL: data['eventImageURL'] ?? "null",
          discussionPoints: data['discussionPoints'] ?? "old doc" ?? "old doc",
          eventType: data['eventType'] ?? "old doc" ?? "old doc",
          eventCategory: data['eventCategory'] ?? "old doc" ?? "old doc",
          fdpProposedBy: data['fdpProposedBy'] ?? "old doc" ?? "old doc",
          schoolCentre: data['schoolCentre'] ?? "old doc" ?? "old doc",
          coordinator1: data['coordinator1'] ?? "old doc" ?? "old doc",
          coordinator2: data['coordinator2'] ?? "old doc" ?? "old doc",
          coordinator3: data['coordinator3'] ?? "old doc" ?? "old doc",
          attendancePresent: data['attendancePresent'] ?? "0",
          issues: Map<String, Map<String, String>>.from(data['issues']),
          expense: data['expense'] ?? "0",
          revenue: data['revenue'] ?? "0",
          budget: data['budget'] ?? "0",
          expectedRevenue: data['expectedRevenue'] ?? "0",
        ),
      );
    }

    //Clubs list
    final clubquerySnapshot = await firestore.collection("Clubs").get();
    List<Club> clubs = [];

    for (final docSnapshot in clubquerySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();

      clubs.add(
        Club(
          clubId: data['clubId'],
          clubName: data['clubName'],
          bio: data['bio'],
          email: data['email'],
          events: List<String>.from(data['events']),
          approvers: List<String>.from(data['approvers']),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<SearchModel>(context, listen: false)
          .initEventClubList(events, clubs);
    });

    // for (final docSnapshot in querySnapshot.docs) {
    //   Map<String, dynamic> docData = docSnapshot.data();
    //   String docDataString = jsonEncode(docData);
    //   await secureStorage.writer(key: "eventData", value: docDataString);
    // }
  }

  //get all participants
  Future<void> getParticipantData(BuildContext context) async {
    final querySnapshotusers = await firestore.collection("app_users").get();

    List<Users> userList = [];

    for (final docSnapshot in querySnapshotusers.docs) {
      Map<String, dynamic> data = docSnapshot.data();

      if (data['role'] == 0) {
        continue;
      }

      userList.add(Users(
        userId: data['userid'],
        name: data['name'],
        email: data['email'],
        clubs: List<String>.from(data['clubs']),
        events: List<String>.from(data['events']),
        organizedEvents: List<String>.from(data['organized_events']),
        approvalEvents: List<String>.from(data['approval_events']),
        role: data['role'],
        phoneNo: data['phone_no'],
        regNo: data['reg_no'],
        profileImageURL: data['profileImageURL'] ?? "null",
        fcmToken: data['fcmToken'] ?? "",
      ));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ApproverSearchModel>(context, listen: false)
          .initUserList(userList);
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await docref.update(newinfo); //push the object
  }

  Future<void> updateEvent(String eventId, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("Events").doc(eventId);
    await docref.update(newinfo); //push the object
    List<String> events = [];

    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    for (final eventId in currentUserData['events']) {
      final event = await firestore.collection("Events").doc(eventId).get();
      Map<String, dynamic> eventData = event.data()!;
      String eventDataString = jsonEncode(eventData);
      events.add(eventDataString);
    }

    String eventsString = events.join("JOIN");
    await secureStorage.writer(key: "events", value: eventsString);
  }

  //details of specific club
  Future<List<Event>> getClubEvents(String clubId) async {
    final querySnapshotEvent = await firestore.collection("Events").get();
    final querySnapshotClub =
        await firestore.collection("Clubs").doc(clubId).get();
    Map<String, dynamic> selectedClub = querySnapshotClub.data()!;

    List<Event> events = [];

    for (final docSnapshot in querySnapshotEvent.docs) {
      Map<String, dynamic> data = docSnapshot.data();

      if (!selectedClub["events"].contains(data["eventId"])) {
        continue;
      }

      Map<String, DateTime> dateTime = {
        'startTime': (data['dateTime']['startTime'] as Timestamp).toDate(),
        'endTime': (data['dateTime']['endTime'] as Timestamp).toDate(),
      };

      try {
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
            eventImageURL: data['eventImageURL'] ?? "null",
            discussionPoints: data['discussionPoints'] ?? "old doc",
            eventType: data['eventType'] ?? "old doc",
            eventCategory: data['eventCategory'] ?? "old doc",
            fdpProposedBy: data['fdpProposedBy'] ?? "old doc",
            schoolCentre: data['schoolCentre'] ?? "old doc",
            coordinator1: data['coordinator1'] ?? "old doc",
            coordinator2: data['coordinator2'] ?? "old doc",
            coordinator3: data['coordinator3'] ?? "old doc",
            attendancePresent: data['attendancePresent'] ?? "0",
            issues: Map<String, Map<String, String>>.from(data['issues']),
            expense: data['expense'] ?? "0",
            revenue: data['revenue'] ?? "0",
            budget: data['budget'] ?? "0",
            expectedRevenue: data['expectedRevenue'] ?? "0",
          ),
        );
      } catch (e) {}
    }

    return events;
  }

  Future<void> addEvent(Event event) async {
    final docref = firestore.collection("Events").doc(event.eventId.toString());
    Map<String, dynamic> obj = {
      "clubId": event.clubId,
      "dateTime": event.dateTime,
      "description": event.description,
      "eventId": event.eventId,
      "eventName": event.eventName,
      "location": event.location,
      "fee": event.fee,
      "organisers": event.organisers,
      "comments": event.comments,
      "participants": event.participants,
      "likes": event.likes,
      "eventImageURL": event.eventImageURL,
      "discussionPoints": event.discussionPoints,
      "eventType": event.eventType,
      "eventCategory": event.eventCategory,
      "fdpProposedBy": event.fdpProposedBy,
      "schoolCentre": event.schoolCentre,
      "coordinator1": event.coordinator1,
      "coordinator2": event.coordinator2,
      "coordinator3": event.coordinator3,
      "attendancePresent": event.attendancePresent,
      "issues": event.issues,
      "expense": event.expense,
      "revenue": event.revenue,
      "budget": event.budget,
    };
    await docref.set(obj);

    // update approved status
    final approvalRef = firestore.collection("Approvals").doc(event.eventId);
    await approvalRef.update({"approved": 1});

    //update club events
    final clubref = firestore.collection("Clubs").doc(event.clubId);
    final club = await clubref.get();
    Map<String, dynamic> clubData = club.data()!;
    List<String> events = List<String>.from(clubData["events"]);
    events.add(event.eventId);
    await clubref.update({"events": events});
  }

  Future<void> addApproval(Approval approval) async {
    final docref =
        firestore.collection("Approvals").doc(approval.approvalId.toString());
    Map<String, dynamic> obj = {
      "clubId": approval.clubId,
      "dateTime": approval.dateTime,
      "description": approval.description,
      "approvalId": approval.approvalId,
      "eventName": approval.eventName,
      "location": approval.location,
      "fee": approval.fee,
      "organisers": approval.organisers,
      "comments": approval.comments,
      "participants": approval.participants,
      "likes": approval.likes,
      "eventImageURL": approval.eventImageURL,
      "approved": approval.approved
    };
    for (var organiser in approval.organisers) {
      var orgRef = firestore.collection("app_users").doc(organiser);
      var org = await orgRef.get();
      if (org.data() == null) {
        orgRef = firestore
            .collection("app_users")
            .doc("kBm7TDAkjyTSV8DisavuuuthSs92");
        org = await orgRef.get();
        obj = {
          "clubId": approval.clubId,
          "dateTime": approval.dateTime,
          "description": approval.description,
          "approvalId": approval.approvalId,
          "eventName": approval.eventName,
          "location": approval.location,
          "fee": approval.fee,
          "organisers": ["kBm7TDAkjyTSV8DisavuuuthSs92"],
          "comments": approval.comments,
          "participants": approval.participants,
          "likes": approval.likes,
          "eventImageURL": approval.eventImageURL,
          "approved": approval.approved
        };
      }
      print("done");
      print(org.data());
      Map<String, dynamic> orgData = org.data()!;
      List<String> approvalEvents =
          List<String>.from(orgData["approval_events"]);
      approvalEvents.add(approval.approvalId);
      await orgRef.update({"approval_events": approvalEvents});
    }

    await docref.set(obj);

    //update club events
    // final clubref = firestore.collection("Clubs").doc(event.clubId);
    // final club = await clubref.get();
    // Map<String, dynamic> clubData = club.data()!;
    // List<String> events = List<String>.from(clubData["events"]);
    // events.add(event.eventId);
    // await clubref.update({"events": events});
  }

  Future<List<Approval>> getApprovalList(String organiserId) async {
    List<Approval> approvalList = [];
    final orgRef = firestore.collection("app_users").doc(organiserId);
    final org = await orgRef.get();
    Map<String, dynamic> currentOrgData = org.data()!;
    for (var approvalId in currentOrgData['approval_events']) {
      final approval =
          await firestore.collection("Approvals").doc(approvalId).get();
      Map<String, dynamic> approvalData = approval.data()!;
      if (approvalData['approved'] == 0) {
        approvalList.add(
          Approval(
            clubId: approvalData['clubId'],
            dateTime: approvalData['dateTime'],
            description: approvalData['description'],
            approvalId: approvalData['approvalId'],
            eventName: approvalData['eventName'],
            location: approvalData['location'],
            fee: approvalData['fee'],
            organisers: List<String>.from(approvalData['organisers']),
            comments: Map<String, String>.from(approvalData['comments']),
            participants: List<String>.from(approvalData['participants']),
            likes: approvalData['likes'],
            eventImageURL: approvalData['eventImageURL'] ?? "null",
            approved: approvalData['approved'],
          ),
        );
      }
    }
    return approvalList;
  }

  Future<void> getOrganizedEvents(BuildContext context) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    final querySnapshot = await firestore.collection("Events").get();
    List<Event> Aevents = [];
    for (final docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Map<String, DateTime> dateTime = {
        'startTime': (data['dateTime']['startTime'] as Timestamp).toDate(),
        'endTime': (data['dateTime']['endTime'] as Timestamp).toDate(),
      };

      if (!currentUserData['organized_events'].contains(data['eventId'])) {
        continue;
      }

      Aevents.add(
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
          eventImageURL: data['eventImageURL'] ?? "null",
          discussionPoints: data['discussionPoints'] ?? "old doc",
          eventType: data['eventType'] ?? "old doc",
          eventCategory: data['eventCategory'] ?? "old doc",
          fdpProposedBy: data['fdpProposedBy'] ?? "old doc",
          schoolCentre: data['schoolCentre'] ?? "old doc",
          coordinator1: data['coordinator1'] ?? "old doc",
          coordinator2: data['coordinator2'] ?? "old doc",
          coordinator3: data['coordinator3'] ?? "old doc",
          attendancePresent: data['attendancePresent'] ?? "0",
          issues: Map<String, Map<String, String>>.from(data['issues']),
          expense: data['expense'] ?? "0",
          revenue: data['revenue'] ?? "0",
          budget: data['budget'] ?? "0",
          expectedRevenue: data['expectedRevenue'] ?? "0",
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ApproverEventSearchModel>(context, listen: false)
          .initeventList(Aevents);
    });
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

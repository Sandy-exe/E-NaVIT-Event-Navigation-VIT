import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit_main/components/approver_search_model.dart';
import 'package:enavit_main/components/approver_event_search_model.dart';
import 'package:enavit_main/models/og_models.dart';
import 'package:enavit_main/Data/secure_storage.dart';
import 'package:enavit_main/components/home_search_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// import 'package:enavit_main/services/authentication_service.dart';

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
      "profileImageURL": newUser.profileImageURL,
      "fcmToken": newUser.fcmToken,
      "favorites": newUser.favorites,
      "followingClubs": newUser.followingClubs,
      "notifications": newUser.notifications,
      "clubIds": newUser.clubIds,
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
    try {
      final currentUser =
          await firestore.collection("app_users").doc(uid).get();

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
          'endTime': (eventData['dateTime']['endTime'] as Timestamp)
              .toDate()
              .toString(),
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
            expense: eventData['expense'] ?? [],
            revenue: eventData['revenue'] ?? "0",
            budget: eventData['budget'] ?? "0",
            attendancePresent: eventData['attendancePresent'] ?? [],
            issues: Map<String, Map<String, String>>.from(eventData['issues']),
            expectedRevenue: eventData['expectedRevenue'] ?? "0",
          ),
        );

        String eventDataString = jsonEncode(eventObj);
        events.add(eventDataString);
      }

      print("userdata: $events");

      String eventsString = events.join("JOIN");
      await secureStorage.writer(key: "events", value: eventsString);
      print("userdata: $eventsString");
    } catch (e) {
      print(e);
    }
  }

  Future<Club> getClubData(String clubId) async {
    final club = await firestore.collection("Clubs").doc(clubId).get();
    Map<String, dynamic> clubData = club.data()!;
    return Club(
      clubId: clubData['clubId'],
      clubName: clubData['clubName'],
      bio: clubData['bio'],
      email: clubData['email'],
      events: List<String>.from(clubData['events']),
      approvers: List<String>.from(clubData['approvers']),
      followers: List<String>.from(clubData['followers']),
      posts: List<String>.from(clubData['posts']),
      revenue: clubData['revenue'],
      expense: clubData['expense'],
    );
  }

  //details of all clubs and events
  Future<void> getEventClubData(BuildContext context) async {
    List<Event> events = [];
    try {
      final querySnapshot = await firestore.collection("Events").get();

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
            discussionPoints:
                data['discussionPoints'] ?? "old doc" ?? "old doc",
            eventType: data['eventType'] ?? "old doc" ?? "old doc",
            eventCategory: data['eventCategory'] ?? "old doc" ?? "old doc",
            fdpProposedBy: data['fdpProposedBy'] ?? "old doc" ?? "old doc",
            schoolCentre: data['schoolCentre'] ?? "old doc" ?? "old doc",
            coordinator1: data['coordinator1'] ?? "old doc" ?? "old doc",
            coordinator2: data['coordinator2'] ?? "old doc" ?? "old doc",
            coordinator3: data['coordinator3'] ?? "old doc" ?? "old doc",
            attendancePresent: data['attendancePresent'] ?? [],
            issues: Map<String, Map<String, String>>.from(data['issues']),
            expense: data['expense'] ?? [],
            revenue: data['revenue'] ?? "0",
            budget: data['budget'] ?? "0",
            expectedRevenue: data['expectedRevenue'] ?? "0",
          ),
        );
      }

      print(events.length);
    } catch (e) {
      print(e);
    }

    //Clubs list

    try {
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
            approvers: List<String>.from(data['approvers'] ?? []),
            followers: List<String>.from(data['followers']),
            posts: List<String>.from(data['posts']),
            revenue: data['revenue'],
            expense: data['expense'],
          ),
        );
      }
      print(clubs.length);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Provider.of<SearchModel>(context, listen: false)
            .initEventClubList(events, clubs);
      });
    } catch (e) {
      print(e);
    }

    // for (final docSnapshot in querySnapshot.docs) {
    //   Map<String, dynamic> docData = docSnapshot.data();
    //   String docDataString = jsonEncode(docData);
    //   await secureStorage.writer(key: "eventData", value: docDataString);
    // }
  }

  Future<void> getClubListData(BuildContext context) async {
    List<Event> events = [];
    try {
      final querySnapshot = await firestore.collection("Events").get();

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
            discussionPoints:
                data['discussionPoints'] ?? "old doc" ?? "old doc",
            eventType: data['eventType'] ?? "old doc" ?? "old doc",
            eventCategory: data['eventCategory'] ?? "old doc" ?? "old doc",
            fdpProposedBy: data['fdpProposedBy'] ?? "old doc" ?? "old doc",
            schoolCentre: data['schoolCentre'] ?? "old doc" ?? "old doc",
            coordinator1: data['coordinator1'] ?? "old doc" ?? "old doc",
            coordinator2: data['coordinator2'] ?? "old doc" ?? "old doc",
            coordinator3: data['coordinator3'] ?? "old doc" ?? "old doc",
            attendancePresent: data['attendancePresent'] ?? [],
            issues: Map<String, Map<String, String>>.from(data['issues']),
            expense: data['expense'] ?? [],
            revenue: data['revenue'] ?? "0",
            budget: data['budget'] ?? "0",
            expectedRevenue: data['expectedRevenue'] ?? "0",
          ),
        );
      }

      print(events.length);
    } catch (e) {
      print(e);
    }

    events = [];
    //Clubs list

    try {
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
            approvers: List<String>.from(data['approvers'] ?? []),
            followers: List<String>.from(data['followers']),
            posts: List<String>.from(data['posts']),
            revenue: data['revenue'],
            expense: data['expense'],
          ),
        );
      }
      print(clubs.length);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Provider.of<SearchModel>(context, listen: false)
            .initEventClubList(events, clubs);
      });
    } catch (e) {
      print(e);
    }

    // for (final docSnapshot in querySnapshot.docs) {
    //   Map<String, dynamic> docData = docSnapshot.data();
    //   String docDataString = jsonEncode(docData);
    //   await secureStorage.writer(key: "eventData", value: docDataString);
    // }
  }

// // Get clubs
//   Future<void> getClubListData(BuildContext context) async {
//     //Clubs list
//     try {
//       final clubquerySnapshot = await firestore.collection("Clubs").get();
//       List<Club> clubs = [];

//       for (final docSnapshot in clubquerySnapshot.docs) {
//         Map<String, dynamic> data = docSnapshot.data();

//         clubs.add(
//           Club(
//             clubId: data['clubId'],
//             clubName: data['clubName'],
//             bio: data['bio'],
//             email: data['email'],
//             events: List<String>.from(data['events']),
//             approvers: List<String>.from(data['approvers'] ?? []),
//             followers: List<String>.from(data['followers']),
//             posts: List<String>.from(data['posts']),
//             revenue: data['revenue'],
//             expense: data['expense'],
//           ),
//         );
//       }
//       print(clubs.length);

//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         Provider.of<SearchModel>(context, listen: false)
//             .initEventClubList(clubs);
//       });
//     } catch (e) {
//       print(e);
//     }

//     // for (final docSnapshot in querySnapshot.docs) {
//     //   Map<String, dynamic> docData = docSnapshot.data();
//     //   String docDataString = jsonEncode(docData);
//     //   await secureStorage.writer(key: "eventData", value: docDataString);
//     // }
//   }

  //get all participants
  Future<void> getParticipantData(BuildContext context) async {
    final querySnapshotusers = await firestore.collection("app_users").get();

    List<Users> userList = [];

    for (final docSnapshot in querySnapshotusers.docs) {
      Map<String, dynamic> data = docSnapshot.data();

      try {
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
          favorites: List<String>.from(data['favorites']),
          followingClubs: List<String>.from(data['followingClubs']),
          notifications: List<String>.from(data['notifications']),
          clubIds: List<String>.from(data['clubIds']),
          attendedEvents: List<String>.from(data['attendedEvents']),
        ));
      } catch (e) {
        print(e);
        print(data['userid']);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ApproverSearchModel>(context, listen: false)
          .initUserList(userList);
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> newinfo) async {
    debugPrint("from user update" + newinfo.toString());
    final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await docref.update(newinfo); //push the object
  }

  Future<void> updateClub(String clubid, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("Clubs").doc(clubid);
    await docref.update(newinfo); //push the object
  }

  Future<void> updateEvent(String eventId, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("Events").doc(eventId);
    final docSnapshot = await docref.get();
    Map<String, dynamic> eventData = docSnapshot.data()!;

    //for updating revenue in club if the updateEvent invoked in userPage
    if (newinfo.containsKey('userId')) {
      final clubref = firestore.collection("Clubs").doc(eventData['clubId']);
      await clubref.update({
        "revenue": (double.parse(eventData['revenue']) +
                double.parse(eventData['fee']))
            .toString()
      });

      List<String> participantsList =
          List<String>.from(eventData['participants']);
      participantsList.add(newinfo['userId']);
      newinfo = {};
      newinfo['participants'] = participantsList;
      print("newinfo: $newinfo");
      newinfo['revenue'] =
          (participantsList.length * (double.parse(eventData['fee'])))
              .toString();

      print("newinfo_changed: $newinfo");

      await docref.update(newinfo);
    }

    //push the object
    List<String> events = [];

    //check on the below code and its usage
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    if (!currentUserData['events'].contains(eventId)) {
      currentUserData['events'].add(eventId);
    }

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
        "attendancePresent": eventData['attendancePresent'],
      };
      String eventDataString = jsonEncode(eventObj);
      events.add(eventDataString);

      String updatedUserData = jsonEncode(currentUserData);

      await secureStorage.writer(
          key: "currentUserData", value: updatedUserData);
    }

    String eventsString = events.join("JOIN");

    print(events.length);

    await secureStorage.writer(key: "events", value: eventsString);
    String eventString = await secureStorage.reader(key: "events") ?? "null";

    List<String> userEvent = eventString.split("JOIN");
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
            attendancePresent: data['attendancePresent'] ?? [],
            issues: Map<String, Map<String, String>>.from(data['issues']),
            expense: data['expense'] ?? [],
            revenue: data['revenue'] ?? "0",
            budget: data['budget'] ?? "0",
            expectedRevenue: data['expectedRevenue'] ?? "0",
          ),
        );
      } catch (e) {
        print(e);
      }
    }

    return events;
  }

  Future<void> addEvent(Event event) async {
    final docref = firestore.collection("Events").doc(event.eventId.toString());
    print(event.clubId);
    //update club events
    final clubref = firestore.collection("Clubs").doc(event.clubId);
    final club = await clubref.get();
    Map<String, dynamic> clubData = club.data()!;
    List<String> events = List<String>.from(clubData["events"]);
    events.add(event.eventId);
    await clubref.update({"events": events});

    List<String> organisers =
        List<String>.from(clubData["approvers"]).take(2).toList();

    //organiser is changed in the below obj
    Map<String, dynamic> obj = {
      "clubId": event.clubId,
      "dateTime": event.dateTime,
      "description": event.description,
      "eventId": event.eventId,
      "eventName": event.eventName,
      "location": event.location,
      "fee": event.fee,
      "organisers": organisers.toSet().toList(),
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

    for (var orga in organisers) {
      final orgRef = firestore.collection("app_users").doc(orga);
      final org = await orgRef.get();

      Map<String, dynamic> orgData = org.data()!;
      List<String> orgEvents = List<String>.from(orgData["organized_events"]);
      orgEvents.add(event.eventId);
      await orgRef.update({"organized_events": orgEvents});
    }

    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    List<String> eventsList =
        List<String>.from(currentUserData['organized_events']);
    eventsList.add(event.eventId);
    currentUserData['organized_events'] = eventsList;

    String updatedUserData = jsonEncode(currentUserData);

    await secureStorage.writer(key: "currentUserData", value: updatedUserData);
  }

  Future<void> rejectApproval(String approvalID) async {
    final approvalRef = firestore.collection("Approvals").doc(approvalID);
    //await approvalRef.update({"approved": 1});

    //final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await approvalRef.update({
      //"comments": approval.comments,
      //"participants": approval.participants,
      //"likes": approval.likes,
      //"eventImageURL": approval.eventImageURL,1
      "approved": 2,
    }); //push the object
  }

  Future<void> approveApproval(String approvalID, Approval approval) async {
    final approvalRef = firestore.collection("Approvals").doc(approvalID);
    //await approvalRef.update({"approved": 1});

    //final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await approvalRef.update({
      "clubId": approval.clubId,
      "dateTime": approval.dateTime,
      "description": approval.description,
      //approvalId": approval.approvalId,
      "eventName": approval.eventName,
      "location": approval.location,
      //"fee": approval.fee,
      "organisers": approval.organisers,
      //"comments": approval.comments,
      //"participants": approval.participants,
      //"likes": approval.likes,
      //"eventImageURL": approval.eventImageURL,
      "approved": 1,
      "discussionPoints": approval.discussionPoints,
      "eventType": approval.eventType,
      "eventCategory": approval.eventCategory,
      "fdpProposedBy": approval.fdpProposedBy,
      "schoolCentre": approval.schoolCentre,
      "coordinator1": approval.coordinator1,
      "coordinator2": approval.coordinator2,
      "coordinator3": approval.coordinator3,
      "budget": approval.budget
    }); //push the object
  }

  Future<void> closeApproval(String approvalID) async {
    final approvalRef = firestore.collection("Approvals").doc(approvalID);
    //await approvalRef.update({"approved": 1});

    //final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await approvalRef.update({
      //"comments": approval.comments,
      //"participants": approval.participants,
      //"likes": approval.likes,
      //"eventImageURL": approval.eventImageURL,1
      "approved": 3,
    }); //push the object
  }

  Future<String> generateUniqueApprovalId() async {
    var uuid = Uuid();
    String uniqueApprovalId;

    // Fetch all existing approval IDs
    final approvalRefs = await firestore.collection("Approvals").get();
    final existingApprovalIds = approvalRefs.docs.map((doc) => doc.id).toList();

    do {
      uniqueApprovalId = uuid.v1();
    } while (existingApprovalIds.contains(uniqueApprovalId));

    return uniqueApprovalId;
  }

  Future<String> generateUniqueannouncementId() async {
    var uuid = Uuid();
    String uniqueAnnoucenemtId;

    // Fetch all existing approval IDs
    final announcementRefs =
        await firestore.collection("EventAnnouncement").get();
    final existingAnnouncementIds =
        announcementRefs.docs.map((doc) => doc.id).toList();

    do {
      uniqueAnnoucenemtId = uuid.v1();
    } while (existingAnnouncementIds.contains(uniqueAnnoucenemtId));

    return uniqueAnnoucenemtId;
  }


  Future<void> addClub(Club club) async {
    print(club);
    // String approverID = await generateUniqueApprovalId();

    // print(approverID);
    Map<String, dynamic> obj = {
      "approvers": club.approvers,
      "bio": club.bio,
      "clubId": club.clubId,
      "clubName": club.clubName,
      "email": club.email,
      "events": club.events,
      "expense": club.expense,
      "followers": club.followers,
      "posts": club.posts,
      "revenue": club.revenue,
    };

    // for (var organiser in approval.organisers) {
    //   print(organiser);
    //   final orgRef = firestore.collection("app_users").doc(organiser);
    //   final org = await orgRef.get();
    //   Map<String, dynamic> orgData = org.data()!;
    //   List<String> approvalEvents =
    //       List<String>.from(orgData["approval_events"]);
    //   approvalEvents.add(approverID);
    //   await orgRef.update({"approval_events": approvalEvents});

    //   print("approval_events: $approvalEvents");
    // }

    await firestore.collection("Clubs").doc(club.clubId).set(obj);

    //update club events
    // final clubref = firestore.collection("Clubs").doc(event.clubId);
    // final club = await clubref.get();
    // Map<String, dynamic> clubData = club.data()!;
    // List<String> events = List<String>.from(clubData["events"]);
    // events.add(event.eventId);
    // await clubref.update({"events": events});
  }


  Future<void> addApproval(Approval approval) async {
    print(approval);
    String approverID = await generateUniqueApprovalId();

    print(approverID);
    Map<String, dynamic> obj = {
      "clubId": approval.clubId,
      "dateTime": approval.dateTime,
      "description": approval.description,
      "approvalId": approverID,
      "eventName": approval.eventName,
      "location": approval.location,
      //"fee": approval.fee,
      "organisers": approval.organisers,
      //"comments": approval.comments,
      //"participants": approval.participants,
      //"likes": approval.likes,
      //"eventImageURL": approval.eventImageURL,
      "approved": approval.approved,
      "discussionPoints": approval.discussionPoints,
      "eventType": approval.eventType,
      "eventCategory": approval.eventCategory,
      "fdpProposedBy": approval.fdpProposedBy,
      "schoolCentre": approval.schoolCentre,
      "coordinator1": approval.coordinator1,
      "coordinator2": approval.coordinator2,
      "coordinator3": approval.coordinator3,
      "budget": approval.budget
    };

    for (var organiser in approval.organisers) {
      print(organiser);
      final orgRef = firestore.collection("app_users").doc(organiser);
      final org = await orgRef.get();
      Map<String, dynamic> orgData = org.data()!;
      List<String> approvalEvents =
          List<String>.from(orgData["approval_events"]);
      approvalEvents.add(approverID);
      await orgRef.update({"approval_events": approvalEvents});

      print("approval_events: $approvalEvents");
    }

    await firestore.collection("Approvals").doc(approverID).set(obj);

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
    print("organiserId: $organiserId");
    print(currentOrgData);
    for (var approvalId in currentOrgData['approval_events']) {
      final approval =
          await firestore.collection("Approvals").doc(approvalId).get();
      Map<String, dynamic> approvalData = approval.data()!;
      if (approvalData['approved'] == 0 || approvalData['approved'] == 2) {
        approvalList.add(
          Approval(
            clubId: approvalData['clubId'],
            dateTime: approvalData['dateTime'],
            description: approvalData['description'],
            approvalId: approvalData['approvalId'],
            eventName: approvalData['eventName'],
            location: approvalData['location'],
            //fee: approvalData['fee'],
            organisers: List<String>.from(approvalData['organisers']),
            //comments: Map<String, String>.from(approvalData['comments']),
            //participants: List<String>.from(approvalData['participants']),
            //likes: approvalData['likes'],
            //eventImageURL: approvalData['eventImageURL'] ?? "null",
            approved: approvalData['approved'],
            discussionPoints:
                approvalData['discussionPoints'] ?? "old doc" ?? "old doc",
            eventType: approvalData['eventType'] ?? "old doc" ?? "old doc",
            eventCategory:
                approvalData['eventCategory'] ?? "old doc" ?? "old doc",
            fdpProposedBy:
                approvalData['fdpProposedBy'] ?? "old doc" ?? "old doc",
            schoolCentre:
                approvalData['schoolCentre'] ?? "old doc" ?? "old doc",
            coordinator1:
                approvalData['coordinator1'] ?? "old doc" ?? "old doc",
            coordinator2:
                approvalData['coordinator2'] ?? "old doc" ?? "old doc",
            coordinator3:
                approvalData['coordinator3'] ?? "old doc" ?? "old doc",
            budget: approvalData['budget'] ?? "old doc" ?? "old doc",
          ),
        );
      }
    }
    return approvalList;
  }

  Future<List<Approval>> getApprovedApprovalsList(String organiserId) async {
    print("organiserId: $organiserId");
    List<Approval> approvalList = [];
    final orgRef = firestore.collection("app_users").doc(organiserId);
    final org = await orgRef.get();
    Map<String, dynamic> currentOrgData = org.data()!;
    print(currentOrgData['approval_events']);
    for (var approvalId in currentOrgData['approval_events']) {
      print(approvalId);
      final approval =
          await firestore.collection("Approvals").doc(approvalId).get();
      Map<String, dynamic> approvalData = approval.data()!;
      if (approvalData['approved'] == 1) {
        approvalList.add(
          Approval(
            clubId: approvalData['clubId'],
            dateTime: approvalData['dateTime'],
            description: approvalData['description'],
            approvalId: approvalData['approvalId'],
            eventName: approvalData['eventName'],
            location: approvalData['location'],
            //fee: approvalData['fee'],
            organisers: List<String>.from(approvalData['organisers']),
            //comments: Map<String, String>.from(approvalData['comments']),
            //participants: List<String>.from(approvalData['participants']),
            //likes: approvalData['likes'],
            //eventImageURL: approvalData['eventImageURL'] ?? "null",
            approved: approvalData['approved'],
            discussionPoints:
                approvalData['discussionPoints'] ?? "old doc" ?? "old doc",
            eventType: approvalData['eventType'] ?? "old doc" ?? "old doc",
            eventCategory:
                approvalData['eventCategory'] ?? "old doc" ?? "old doc",
            fdpProposedBy:
                approvalData['fdpProposedBy'] ?? "old doc" ?? "old doc",
            schoolCentre:
                approvalData['schoolCentre'] ?? "old doc" ?? "old doc",
            coordinator1:
                approvalData['coordinator1'] ?? "old doc" ?? "old doc",
            coordinator2:
                approvalData['coordinator2'] ?? "old doc" ?? "old doc",
            coordinator3:
                approvalData['coordinator3'] ?? "old doc" ?? "old doc",
            budget: approvalData['coordinator3'] ?? "old doc" ?? "old doc",
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
          attendancePresent: data['attendancePresent'] ?? [],
          issues: Map<String, Map<String, String>>.from(data['issues']),
          expense: data['expense'] ?? [],
          revenue: data['revenue'] ?? "0",
          budget: data['budget'] ?? "0",
          expectedRevenue: data['expectedRevenue'] ?? "0",
        ),
      );
      print(Aevents);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ApproverEventSearchModel>(context, listen: false)
          .initeventList(Aevents);
    });
  }

  Future<bool> toggleFavEvents(String eventId) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    List<String> favEvents = List<String>.from(currentUserData['favorites']);

    final EventRef = firestore.collection("Events").doc(eventId);
    bool isFav = false;

    final event = await EventRef.get();
    Map<String, dynamic> eventData = event.data()!;
    if (favEvents.contains(eventId)) {
      favEvents.remove(eventId);
      eventData.update("likes", (value) => value - 1);
      await EventRef.update(eventData);
      isFav = false;
    } else {
      favEvents.add(eventId);
      eventData.update("likes", (value) => value + 1);
      await EventRef.update(eventData);
      isFav = true;
    }

    currentUserData['favorites'] = favEvents;

// Convert the map back to a JSON string
    String updatedUserData = jsonEncode(currentUserData);

// Store the updated user data back to secure storage
    await secureStorage.writer(key: "currentUserData", value: updatedUserData);

    final userRef =
        firestore.collection("app_users").doc(currentUserData['userid']);
    await userRef.update({"favorites": favEvents});

    return isFav;
  }

  Future<bool> checkFavEvents(String eventId) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    List<String> favEvents = List<String>.from(currentUserData['favorites']);
    return favEvents.contains(eventId);
  }

  Future<bool> checkFollowClub(String clubId) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    List<String> followedClubs =
        List<String>.from(currentUserData['followingClubs']);
    return followedClubs.contains(clubId);
  }

  Future<bool> toggleFollowClubs(String clubId) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    List<String> followedClubs =
        List<String>.from(currentUserData['followingClubs']);

    final ClubRef = firestore.collection("Clubs").doc(clubId);
    bool isFollowing = false;

    final club = await ClubRef.get();
    Map<String, dynamic> clubData = club.data()!;
    List<String> followers = List<String>.from(clubData['followers']);
    if (followedClubs.contains(clubId)) {
      followedClubs.remove(clubId);
      followers.remove(currentUserData['userid']);
      clubData['followers'] = followers;
      await ClubRef.update(clubData);
      isFollowing = false;
    } else {
      followedClubs.add(clubId);
      followers.add(currentUserData['userid']);
      clubData['followers'] = followers;
      await ClubRef.update(clubData);
      isFollowing = true;
    }

    currentUserData['followingClubs'] = followedClubs;

// Convert the map back to a JSON string
    String updatedUserData = jsonEncode(currentUserData);

// Store the updated user data back to secure storage
    await secureStorage.writer(key: "currentUserData", value: updatedUserData);

    final userRef =
        firestore.collection("app_users").doc(currentUserData['userid']);
    await userRef.update({"followingClubs": followedClubs});
    return isFollowing;
  }

  Future<List<Event>> getLikedEvents(BuildContext context) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    List<String> favEvents = List<String>.from(currentUserData['favorites']);
    List<Event> likedEvents = [];

    print(favEvents);

    for (final eventId in favEvents) {
      final event = await firestore.collection("Events").doc(eventId).get();
      Map<String, dynamic> eventData = event.data()!;

      Map<String, DateTime> dateTime = {
        'startTime': (eventData['dateTime']['startTime'] as Timestamp).toDate(),
        'endTime': (eventData['dateTime']['endTime'] as Timestamp).toDate(),
      };

      likedEvents.add(
        Event(
          clubId: eventData['clubId'],
          dateTime: dateTime,
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
          attendancePresent: eventData['attendancePresent'] ?? [],
          issues: Map<String, Map<String, String>>.from(eventData['issues']),
          expense: eventData['expense'] ?? [],
          revenue: eventData['revenue'] ?? "0",
          budget: eventData['budget'] ?? "0",
          expectedRevenue: eventData['expectedRevenue'] ?? "0",
        ),
      );
    }
    return likedEvents;
  }

  // Future<List<Event>> getOrganizedEventsView(BuildContext context,String userid) async {
  //   List<Event> organizedEvents = [];

  //   final userRef =
  //       firestore.collection("app_users").doc(userid);

  //   DocumentSnapshot userDoc = await userRef.get();

  //      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

  //   if (userData != null && userData.containsKey('organized_events')) {
  //     organizedEvents = List<Event>.from(userData['organized_events']);
  //   }

  //     return organizedEvents;
  // }

  Future<List<Event>> getOrganizedEventsView(
      BuildContext context, String? userid) async {
    List<Event> organizedEvents = [];

    try {
      if (userid != " ") {
        final userRef = firestore.collection("app_users").doc(userid);

        DocumentSnapshot userDoc = await userRef.get();

        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        List<String> temp = List<String>.from(userData?['organized_events']);

        for (final eventId in temp) {
          final eventDoc =
              await firestore.collection("Events").doc(eventId).get();

          Map<String, dynamic>? eventDataNullable = eventDoc.data();
          if (eventDataNullable == null) {
            debugPrint("Event data not found participant");
            continue;
          }
          Map<String, dynamic> eventData = eventDataNullable;

          Map<String, DateTime> dateTime = {
            'startTime':
                (eventData['dateTime']['startTime'] as Timestamp).toDate(),
            'endTime': (eventData['dateTime']['endTime'] as Timestamp).toDate(),
          };

          organizedEvents.add(
            Event(
              clubId: eventData['clubId'],
              dateTime: dateTime,
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
              attendancePresent: eventData['attendancePresent'] ?? [],
              issues:
                  Map<String, Map<String, String>>.from(eventData['issues']),
              expense: eventData['expense'] ?? [],
              revenue: eventData['revenue'] ?? "0",
              budget: eventData['budget'] ?? "0",
              expectedRevenue: eventData['expectedRevenue'] ?? "0",
            ),
          );
        }

        return organizedEvents;
      }

      Map<String, dynamic> currentUserData = jsonDecode(
          await secureStorage.reader(key: "currentUserData") ?? "null");
      for (final eventId in currentUserData['organized_events']) {
        final eventDoc =
            await firestore.collection("Events").doc(eventId).get();

        Map<String, dynamic>? eventDataNullable = eventDoc.data();
        if (eventDataNullable == null) {
          debugPrint("Event data not found user");
          continue;
        }
        Map<String, dynamic> eventData = eventDataNullable;

        Map<String, DateTime> dateTime = {
          'startTime':
              (eventData['dateTime']['startTime'] as Timestamp).toDate(),
          'endTime': (eventData['dateTime']['endTime'] as Timestamp).toDate(),
        };

        organizedEvents.add(
          Event(
            clubId: eventData['clubId'],
            dateTime: dateTime,
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
            attendancePresent: eventData['attendancePresent'] ?? [],
            issues: Map<String, Map<String, String>>.from(eventData['issues']),
            expense: eventData['expense'] ?? [],
            revenue: eventData['revenue'] ?? "0",
            budget: eventData['budget'] ?? "0",
            expectedRevenue: eventData['expectedRevenue'] ?? "0",
          ),
        );
      }
      return organizedEvents;
    } catch (e) {
      print(e);
      return organizedEvents;
    }
  }

  Future<List<Club>> getFollowedClubs(BuildContext context) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    List<String> followedClubs =
        List<String>.from(currentUserData['followingClubs']);
    List<Club> clubs = [];

    for (final clubId in followedClubs) {
      final club = await firestore.collection("Clubs").doc(clubId).get();
      Map<String, dynamic> clubData = club.data()!;

      clubs.add(
        Club(
          clubId: clubData['clubId'],
          clubName: clubData['clubName'],
          bio: clubData['bio'],
          email: clubData['email'],
          events: List<String>.from(clubData['events']),
          approvers: List<String>.from(clubData['approvers']),
          followers: List<String>.from(clubData['followers']),
          posts: List<String>.from(clubData['posts']),
          revenue: clubData['revenue'],
          expense: clubData['expense'],
        ),
      );
    }

    return clubs;
  }

  Future<Event> getEventDetails(String eventId) async {
    final event = await firestore.collection("Events").doc(eventId).get();
    Map<String, dynamic> eventData = event.data()!;

    Map<String, DateTime> dateTime = {
      'startTime': (eventData['dateTime']['startTime'] as Timestamp).toDate(),
      'endTime': (eventData['dateTime']['endTime'] as Timestamp).toDate(),
    };

    Event eventObj = Event(
      clubId: eventData['clubId'],
      dateTime: dateTime,
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
      attendancePresent: eventData['attendancePresent'] ?? [],
      issues: Map<String, Map<String, String>>.from(eventData['issues']),
      expense: eventData['expense'] ?? [],
      revenue: eventData['revenue'] ?? "0",
      budget: eventData['budget'] ?? "0",
      expectedRevenue: eventData['expectedRevenue'] ?? "0",
    );

    return eventObj;
  }

  Future<Club> getOrganizerClubDetails() async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    final club = await firestore
        .collection("Clubs")
        .doc(currentUserData['clubIds'][0])
        .get();

    return Club(
      clubId: club['clubId'],
      clubName: club['clubName'],
      bio: club['bio'],
      email: club['email'],
      events: List<String>.from(club['events']),
      approvers: List<String>.from(club['approvers']),
      followers: List<String>.from(club['followers']),
      posts: List<String>.from(club['posts']),
      revenue: club['revenue'],
      expense: club['expense'],
    );
  }

  Future<void> updateClubDetails(Club updatedClub) async {
    final clubRef = firestore.collection("Clubs").doc(updatedClub.clubId);
    await clubRef.update({
      "clubName": updatedClub.clubName,
      "bio": updatedClub.bio,
      "email": updatedClub.email,
    });
  }

  Future<void> addEventannouncementDetails(
      EventAnnoucenments announcement) async {
    print(announcement.announcement);
    try {
      announcement.announcementId = await generateUniqueannouncementId();
      final announcementRef = firestore
          .collection("EventAnnouncement")
          .doc(announcement.announcementId);

      Map<String, dynamic> obj = {
        "eventId": announcement.eventId,
        "announcement": announcement.announcement,
        "announcementId": announcement.announcementId,
        "dateTime": announcement.dateTime,
        "userId": announcement.userId,
        "userName": announcement.userName,
        "eventName": announcement.eventName,
        "clubId": announcement.clubId,
      };

      print(obj);
      print("clubId: ${announcement.clubId}");

      final clubRef = firestore.collection("Clubs").doc(announcement.clubId);

      final club = await clubRef.get();
      Map<String, dynamic> clubData = club.data()!;
      List<String> posts = List<String>.from(clubData["posts"]);
      posts.add(announcement.announcementId);
      await clubRef.update({"posts": posts});
      print("Updated club posts");
      await announcementRef.set(obj);
    } catch (e) {
      print(e);
    }
  }

  Future<List<EventAnnoucenments>> getClubPosts(String clubId) async {
    final querySnapshot = await firestore.collection("EventAnnouncement").get();
    List<EventAnnoucenments> announcements = [];

    for (final docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      print(data);

      if (data['clubId'] == clubId) {
        announcements.add(
          EventAnnoucenments(
            announcementId: data['announcementId'],
            eventId: data['eventId'],
            announcement: data['announcement'],
            dateTime: (data['dateTime'] as Timestamp).toDate(),
            userId: data['userId'],
            userName: data['userName'],
            eventName: data['eventName'],
            clubId: data['clubId'],
          ),
        );
      }
    }

    print(announcements);
    return announcements;
  }

  Future<List<EventAnnoucenments>> getEventAnnouncements(String eventId) async {
    try {
      final querySnapshot =
          await firestore.collection("EventAnnouncement").get();
      List<EventAnnoucenments> announcements = [];

      for (final docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data();
        print(data);

        if (data['eventId'] == eventId) {
          announcements.add(
            EventAnnoucenments(
              announcementId: data['announcementId'],
              eventId: data['eventId'],
              announcement: data['announcement'],
              dateTime: (data['dateTime'] as Timestamp).toDate(),
              userId: data['userId'],
              userName: data['userName'],
              eventName: data['eventName'],
              clubId: data['clubId'],
            ),
          );
        }
      }
      print(announcements);
      return announcements;
    } catch (e) {
      print("on getEventAnnouncements");
      print(e);
      return [];
    }
  }

  Future<void> removeAllDocsExceptOne() async {
    try {
      // Hardcoded collection names
      List<String> collectionNames = [
        'Approvals',
        'Clubs',
        'EventAnnouncement',
        'Events',
        'Notifications',
      ];

      // Step 1: Iterate through each specified collection
      for (String collectionName in collectionNames) {
        CollectionReference collection =
            FirebaseFirestore.instance.collection(collectionName);
        QuerySnapshot querySnapshot = await collection.get();

        // Check if there are more than one document
        if (querySnapshot.docs.length > 1) {
          // Keep the first document and delete the rest
          for (int i = 1; i < querySnapshot.docs.length; i++) {
            await querySnapshot.docs[i].reference.delete();
          }
        }

        print("Removed all documents except one in $collectionName");
      }

      print("Deletion completed successfully");
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvents(String eventId) async {
    try {
      final eventRef = firestore.collection("Events").doc(eventId);
      await eventRef.delete();
    } catch (e) {
      print(e);
    }
  }


  Future<void> updateUserRecords() async {
    try {
      // Get all documents in the 'app_users' collection
      QuerySnapshot snapshot = await firestore.collection('app_users').get();

      // Iterate through all documents
      for (DocumentSnapshot doc in snapshot.docs) {
        // Update each document with the new field
        await firestore.collection('app_users').doc(doc.id).update({
          'attendedEvents': [],
        });
        print('Updated user record for ${doc.id}');
      }

      // Log success message
      print('User records updated successfully!');
    } catch (e) {
      // Log error message
      print('Failed to update user records: $e');
    }
  }

  String getCurrentFormattedTimestamp() {
    // Get the current timestamp
    Timestamp timestamp = Timestamp.now();

    // Convert the Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    final String formattedTimestamp = formatter.format(dateTime);

    return formattedTimestamp;
  }

  Future<String> updateExpense(
      Map<String, dynamic> expense, Event event) async {
    final querySnapshot =
        await firestore.collection("Events").doc(event.eventId).get();
    final clubSnapshot =
        await firestore.collection("Clubs").doc(event.clubId).get();

    Map<String, dynamic> clubData = clubSnapshot.data()!;
    Map<String, dynamic> eventData = querySnapshot.data()!;

    print(expense['expense'].runtimeType);

    try {
      // Add timestamp to the expense
      expense['timestamp'] = getCurrentFormattedTimestamp();
      // Check if the expense field exists and is a list
      List<dynamic> expenses = eventData['expense'] ?? [];
      // Add the new expense to the list
      expenses.add(expense);

      // Update the event document with the new expense list
      await firestore.collection("Events").doc(event.eventId).update({
        "expense": expenses,
      });
      // Update the club's total expense
      double currentClubExpense = double.parse(clubData['expense']);
      double newExpense = double.parse(expense['expense']);

      await firestore.collection("Clubs").doc(event.clubId).update({
        "expense": (currentClubExpense + newExpense).toString(),
      });

      print(currentClubExpense + newExpense);

      return "success";
    } catch (e) {
      print('Failed to update expense: $e');
      return "error";
    }
  }

  Future<String> updateExpectedRevenue(
      String expectedRevenue, Event event) async {
    final querySnapshot =
        await firestore.collection("Events").doc(event.eventId).get();
    Map<String, dynamic> eventData = querySnapshot.data()!;

    //revenue in event collections in expected revenue

    try {
      await firestore.collection("Events").doc(event.eventId).update({
        "revenue": expectedRevenue,
      });

      return "success";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future<List<Map<dynamic, dynamic>>> getExpenses(Event event) async {
    final querySnapshot =
        await firestore.collection("Events").doc(event.eventId).get();
    Map<String, dynamic> eventData = querySnapshot.data()!;

    double total_expense = 0.0;

    for (var element in event.expense) {
      print(element);
      total_expense += double.parse(element['expense']);
    }

    List<Map<dynamic, dynamic>> expenses = [];
    for (var element in event.expense) {
      expenses.add(element);
    }

    expenses.add({"Total_Expense": total_expense.toString()});
    print(expenses);
    return expenses;
  }
}

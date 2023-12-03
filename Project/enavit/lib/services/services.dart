import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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
    print("added");
  }

  Future getUserData(String uid) async {
    final currentUser = await firestore.collection("app_users").doc(uid).get();
    print(currentUser.data()!.values.toList());

    //save the data in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> currentUserData = currentUser.data()!;
    String currentUserDataString = jsonEncode(currentUserData);
    await prefs.setString('currentUserData', currentUserDataString);
  }

  // Future<void> deleteTodoItem(String documentId) async {
  //   final DocumentReference documentReference =
  //       firestore.collection('tasks').doc(documentId);
  //   await documentReference.delete();
  // }
}

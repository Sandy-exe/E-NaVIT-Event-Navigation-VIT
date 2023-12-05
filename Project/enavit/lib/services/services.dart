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

  Future<void> updateUser (String uid, Map<String, dynamic> newinfo) async {
    final docref = firestore.collection("app_users").doc(uid);
    // AuthenticationService auth = AuthenticationService();
    // auth.updateMail(newinfo["email"]);
    await docref.update(newinfo);//push the object
  }

  // Future<void> deleteTodoItem(String documentId) async {
  //   final DocumentReference documentReference =
  //       firestore.collection('tasks').doc(documentId);
  //   await documentReference.delete();
  // }










































































































































}

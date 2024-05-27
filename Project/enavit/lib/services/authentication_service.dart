import 'package:enavit/components/compute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/services/services.dart';
import 'package:enavit/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // AndroidOptions _getAndroidOptions() => AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     );
  // final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  SecureStorage secureStorage = SecureStorage();

  Future signIn({required String email, required String password}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        String uid = result.user!.uid.toString();
        var service = Services();
        await service.updateFcmToken(uid);
        await service.getUserData(uid);
        secureStorage.writer(key: "isLoggedIn", value: "true");
        print("Logged in");
      }

      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == "invalid-email") {
        return "Invalid email address";
      }
      return "Error while Performing Request";
    }
  }

  Future signUp(
      {required String email,
      required password,
      required String regno,
      required String phoneno,
      required String name}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = result.user?.uid.toString() ?? "null";
      var service = Services();

      Users newUser = Users(
          userId: uid,
          name: name,
          email: email,
          favorites: [],
          clubs: [],
          events: [],
          organizedEvents: [],
          approvalEvents: [],
          role: 2,
          phoneNo: phoneno,
          regNo: regno,
          profileImageURL: "null", //add profile image in the beginning
          fcmToken: "",
          followingClubs: [],
          notifications: [],
          clubIds: []);
      await service.addUser(newUser);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        return "Invalid email address";
      }
      if (e.code == 'weak-password') {
        return "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email";
      }
    }
  }

  Future<void> signOut(context) async {
    var computeProvider = Provider.of<Compute>(context, listen: false);
    await computeProvider.logout();
    secureStorage.clear();
    await _firebaseAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
  }

  Future<void> updateMail(String newMail) async {
    var user = _firebaseAuth.currentUser;
    await user!.updateEmail(newMail);
  }

  // Future<bool> isUserLoggedIn() async {
  //   // var user = await _firebaseAuth.currentUser();
  //   return user != null;
  // }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enavit/services/services.dart';
import 'package:enavit/models/og_models.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signIn ({required String email, required String password}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);   
      if (result != null) {
        String uid = result.user?.uid.toString() ?? "null";
        var service = Services();
        await service.getUserData(uid);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        return "success";
      } 

      return "failed";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == "invalid-email") {
        return "Invalid email address";
      }
      return "Wrong Credentials";
    }
  }

  Future signUp({required String email, required password, required String regno, required String phoneno, required String name}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        String uid = result.user?.uid.toString() ?? "null";
        var service = Services();

        Users newUser = Users(
          userId: uid,
          name: name,
          email: email,
          clubs: [],
          events: [],
          organizedEvents: [],
          role: 0,
          phoneNo: phoneno,
          regNo: regno,
        );
        await service.addUser(newUser);
        return "success";
      }
      return "failed";
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

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('currentUserData', "");
    await _firebaseAuth.signOut();
    print("signut out");
  }

  // Future<bool> isUserLoggedIn() async {
  //   // var user = await _firebaseAuth.currentUser();
  //   return user != null;
  // }
}

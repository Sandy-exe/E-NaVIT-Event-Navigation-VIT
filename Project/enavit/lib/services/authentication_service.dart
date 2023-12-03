import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signIn ({required String email, required String password}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result != null) {
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

  Future signUp({required String email, required password}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
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
    print("signing out");
    await _firebaseAuth.signOut();
    print("signut out");
  }

  // Future<bool> isUserLoggedIn() async {
  //   // var user = await _firebaseAuth.currentUser();
  //   return user != null;
  // }
}

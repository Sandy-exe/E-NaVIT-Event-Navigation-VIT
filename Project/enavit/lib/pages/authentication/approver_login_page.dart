
import 'package:flutter/material.dart';

import 'package:enavit/services/authentication_service.dart';
import 'package:enavit/Data/secure_storage.dart';

class ApproverLoginPage extends StatefulWidget {
  const ApproverLoginPage({super.key});

  @override
  State<ApproverLoginPage> createState() => _ApproverLoginPageState();
}

class _ApproverLoginPageState extends State<ApproverLoginPage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();

  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Approver",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.mail),
                          labelText: 'Email address',
                          hintText: 'Enter email address',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordTEC,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                          labelText: 'Password',
                          hintText: 'Enter password',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        signIn();

                        // try {
                        //   final credential = await FirebaseAuth.instance
                        //       .signInWithEmailAndPassword(
                        //           email: _emailTEC.text, password: "abcdef");
                        //   print("successful");
                        //   print(credential.user);
                        // } on FirebaseAuthException catch (e) {
                        //   print("UNsuccessful");
                        //   if (e.code == 'user-not-found') {
                        //     print('No user found for that email.');
                        //   } else if (e.code == 'wrong-password') {
                        //     print('Wrong password provided for that user.');
                        //   }
                        // }
                      },
                      child: const Text("Sign in"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password"),

                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void signIn() async {
    final String email = _emailTEC.text;
    final String password = _passwordTEC.text;

    final String result = await _firebaseAuth.signIn(
      email: email,
      password: password,
    );

    
    if (result == "success") {
      SecureStorage secureStorage = SecureStorage();
      await secureStorage.writer(key: "isLoggedIn", value: "true");

      if (context.mounted) Navigator.pushNamed(context, '/index');
      
    } else {
      if (context.mounted) _showToast(context, result);
    }
  }

  void signOut() async {
    _firebaseAuth.signOut();
  }


}


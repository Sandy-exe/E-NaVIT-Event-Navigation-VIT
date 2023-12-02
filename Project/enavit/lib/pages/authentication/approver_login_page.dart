import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApproverLoginPage extends StatefulWidget {
  const ApproverLoginPage({super.key});

  @override
  State<ApproverLoginPage> createState() => _ApproverLoginPageState();
}

class _ApproverLoginPageState extends State<ApproverLoginPage> {
  final TextEditingController _emailTEC = TextEditingController();

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
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                          labelText: 'Password',
                          hintText: 'Enter password',
                          isDense: true),
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print(_emailTEC.text);

                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailTEC.text, password: "abcdef");
                          print("successful");
                        } on FirebaseAuthException catch (e) {
                          print("UNsuccessful");
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
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
}

import 'package:flutter/material.dart';
import 'package:enavit/pages/authentication/approver_login_page.dart';
import 'package:enavit/pages/authentication/participants_login_page.dart';
import 'package:enavit/pages/authentication/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {                
                debugPrint("Approver Login");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApproverLoginPage(),
                  ),
                );
              },
              child: const Text("Approver Login"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("Participant Login");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParticipantLoginPage(),
                  ),
                );
              },
              child: const Text("Participant Login"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("Sign up");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}

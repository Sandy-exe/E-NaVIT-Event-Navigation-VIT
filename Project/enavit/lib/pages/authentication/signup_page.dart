
import 'package:flutter/material.dart';
import 'package:enavit/services/authentication_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final AuthenticationService _firebaseAuth = AuthenticationService();

  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _confirmPasswordTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _firstNameTEC = TextEditingController();
  final TextEditingController _lastNameTEC = TextEditingController();
  final TextEditingController _mobileTEC = TextEditingController();
  final TextEditingController _regNoTEC = TextEditingController();

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
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _firstNameTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          labelText: 'First name',
                          hintText: 'Enter first name',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _lastNameTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Last name',
                          hintText: 'Enter last name',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
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
                      height: 16,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                          labelText: 'Password',
                          hintText: 'Enter password',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _confirmPasswordTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                          labelText: 'Confirm password',
                          hintText: 'Re-enter password',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _mobileTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Mobile number',
                          hintText: 'Enter mobile number',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      controller: _regNoTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.app_registration),
                          labelText: 'Registration number',
                          hintText: 'Enter registration number',
                          isDense: true),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_firstNameTEC.text.isEmpty ||
                            _lastNameTEC.text.isEmpty ||
                            _emailTEC.text.isEmpty ||
                            _confirmPasswordTEC.text.isEmpty ||
                            _mobileTEC.text.isEmpty ||
                            _passwordTEC.text.isEmpty ||
                            _regNoTEC.text.isEmpty) {
                          _showToast(context, "Complete form");
                          return;
                        }
                        if (_passwordTEC.text != _confirmPasswordTEC.text) {
                          _showToast(context, "Passwords do not match");
                          return;
                        }
                        ;
                        // try {
                        //   final credential = await FirebaseAuth.instance
                        //       .createUserWithEmailAndPassword(
                        //     email: _emailTEC.text,
                        //     password: _passwordTEC.text,
                        //   );
                        //   print("succesful");
                        // } on FirebaseAuthException catch (e) {
                        //   print("UNsuccesful");
                        //   if (e.code == "invalid-email") {
                        //     _showToast(context, "Invalid email address");
                        //   }
                        //   if (e.code == 'weak-password') {
                        //     print('The password provided is too weak.');
                        //     _showToast(
                        //         context, "The password provided is too weak");
                        //   } else if (e.code == 'email-already-in-use') {
                        //     print('The account already exists for that email.');
                        //     _showToast(context,
                        //         "The account already exists for that email");
                        //   }
                        // } catch (e) {
                        //   print("UNsuccesful");
                        //   print(e);
                        // }
                        signup();
                      },
                      child: const Text("Sign up"),
                    )
                  ],
                )
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

  void signup() async {
    final String email = _emailTEC.text;
    final String password = _passwordTEC.text;
    final String regno = _regNoTEC.text;
    final String phoneno = _mobileTEC.text;
    final String name = "${_firstNameTEC.text} ${_lastNameTEC.text}";

    
    final String result = await _firebaseAuth.signUp(
        email: email,
        password: password,
        regno: regno,
        phoneno: phoneno,
        name: name,
        );
    print(result);

    if (result == "success") {
      print("successful");
      Navigator.pushNamed(context, '/login');
    } else {
      print("UNsuccessful");
      _showToast(context, result);
    }
  }


}

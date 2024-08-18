
import 'dart:convert';
import 'package:enavit/Custom_widgets/custom_scaffold_authentication.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/pages/authentication/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:enavit/services/authentication_service.dart';
import 'package:enavit/theme/theme.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSnackBarShowing = false;
  bool _isLoading = false;
  final _formSignInKey = GlobalKey<FormState>();
  final AuthenticationService _firebaseAuth = AuthenticationService();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  
  bool rememberPassword = true;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _emailTEC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter Email'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _passwordTEC,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (!isSnackBarShowing) {
                              isSnackBarShowing = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter Password'),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust duration as needed
                                    ),
                                  )
                                  .closed
                                  .then((_) {
                                isSnackBarShowing = false;
                              });
                            }
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            if (_formSignInKey.currentState!.validate() &&
                                rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                                debugPrint("Login SUCCESS");
                                debugPrint("Email: ${_emailTEC.text}");
                                debugPrint("Password: ${_passwordTEC.text}");
                                signIn();
                            } else if (!rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')),
                              );
                            }
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              debugPrint("LinkedIn");
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              child: Image.asset('lib/images/linkedin.png'),
                            ),
                          ),
                          
                          IconButton(
                            onPressed: () {
                              debugPrint("Google");
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('lib/images/google.png'),

                            ),
                          ),
                          
                          IconButton(
                            onPressed: () {
                              debugPrint("Facebook");
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              child: Image.asset('lib/images/facebook.png'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void signIn() async {
    final String email = _emailTEC.text;
    final String password = _passwordTEC.text;

    setState(() {
      _isLoading = true;
    });

      final String result = await _firebaseAuth.signIn(
        email: email,
        password: password,
      );

      SecureStorage storage = SecureStorage();

      String currentUserDataString =
          await storage.reader(key: "currentUserData") ?? "null";

      int userRole = -1;
      if (currentUserDataString != "null") {
        Map<String, dynamic> currentUserData =
            jsonDecode(currentUserDataString); //null not checked properly
        userRole = currentUserData["role"];
      }

      if (result == "success") {
      ScaffoldMessenger.of(context).clearSnackBars();

      if (userRole == 0) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/approver_index',
          (Route<dynamic> route) => false, // This predicate removes all routes
        );
      } else if (userRole == 1 || userRole == 4) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/organiser_index',
            (Route<dynamic> route) =>
                false, // This predicate removes all routes
          );
        }
      } else if (userRole == 3 || userRole == 2 ) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/participant_index',
            (Route<dynamic> route) =>
                false, // This predicate removes all routes
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (Route<dynamic> route) =>
                false, // This predicate removes all routes
          );
        }
      }
    } else {
        if (context.mounted) _showToast(context, result);
      }
    
      setState(() {
        _isLoading = false;
      });
    
  }

  void signOut() async {
    _firebaseAuth.signOut(context);
  }
}

















// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final AuthenticationService _firebaseAuth = AuthenticationService();

//   final TextEditingController _emailTEC = TextEditingController();
//   final TextEditingController _passwordTEC = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Log In",
//                   style: TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 200,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     TextFormField(
//                       keyboardType: TextInputType.emailAddress,
//                       controller: _emailTEC,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.mail),
//                         labelText: 'Email address',
//                         hintText: 'Enter email address',
//                         isDense: true
//                       ),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.visiblePassword,
//                       controller: _passwordTEC,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.key),
//                         labelText: 'Password',
//                         hintText: 'Enter password',
//                         isDense: true
//                       ),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
                        
//                         signIn();
//                       },
//                       child: const Text("Sign in"),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text("Forgot Password"),

//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

  



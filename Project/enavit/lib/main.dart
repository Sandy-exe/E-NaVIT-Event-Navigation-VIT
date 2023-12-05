
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'models/add_event.dart';
import 'package:enavit/pages/intro_page.dart';
import 'package:provider/provider.dart';
import 'package:enavit/pages/authentication/login_page.dart';
import 'package:enavit/pages/authentication/signup_page.dart';
import 'package:enavit/pages/index_page.dart';
import 'package:enavit/pages/main_pages/profile_page.dart';
import 'package:enavit/pages/main_pages/update_profile_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SecureStorage securestorage = SecureStorage();

  //for testing in offline
  // Map<String, dynamic> currentUserData = {"userid": "123",
  //     "name": "santhosh",
  //     "email": "santhosh.kumarasdfas@sadfj",
  //     "clubs": [],
  //     "events": [],
  //     "organized_events": [],
  //     "role": 0,
  //     "phone_no": "9500882564",
  //     "reg_no": "21BCE1829",
  //   };
  // String currentUserDataString = jsonEncode(currentUserData);
  // await securestorage.writer(key: "currentUserData", value: currentUserDataString);
  // await securestorage.writer(key: "isLoggedIn", value: "true" );
  //offline test ends here
  bool isLoggedIn = await securestorage.reader(key: "isLoggedIn") == 'true';
  

  await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB3xdXpZ_CWyvqnHe6PjaEVz-dYsCpRydU",
            appId: "1:1084741784734:android:e31ef7588490b9b9e2978f",
            messagingSenderId: "1084741784734",
            projectId: "e-navit"));
  runApp(Enavit(isLoggedIn: isLoggedIn),);
}

class Enavit extends StatelessWidget {
  final bool isLoggedIn;
  const Enavit({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProvider(
      create: (context) => AddEvent(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enavit',
        initialRoute: isLoggedIn ? '/index' : '/',
        //initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const IntroPage(),
          // Add more routes as needed
          '/login': (context) => const LoginPage(),
          '/signup': (context) =>const SignUpPage(),
          '/index': (context) => const IndexPage(),
          '/profile': (context) => const ProfilePage(),
          '/update_profile': (context) => const UpdateProfile(),
        },
      ),
    );
  }
}


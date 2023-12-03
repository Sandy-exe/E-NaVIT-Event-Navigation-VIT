
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/add_Event.dart';
import 'package:enavit/pages/intro_page.dart';
import 'package:provider/provider.dart';
import 'package:enavit/pages/authentication/login_page.dart';
import 'package:enavit/pages/authentication/signup_page.dart';
import 'package:enavit/pages/index_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  print(isLoggedIn);
  await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB3xdXpZ_CWyvqnHe6PjaEVz-dYsCpRydU",
            appId: "1:1084741784734:android:e31ef7588490b9b9e2978f",
            messagingSenderId: "1084741784734",
            projectId: "e-navit"));
  runApp(Enavit(isLoggedIn: prefs.getBool('isLoggedIn') ?? false),);
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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isLoggedIn ? '/index' : '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const IntroPage(),
          // Add more routes as needed
          '/login': (context) => const LoginPage(),
          '/signup': (context) =>const SignUpPage(),
          '/index': (context) => const IndexPage(),
        },
      ),
    );
  }
}


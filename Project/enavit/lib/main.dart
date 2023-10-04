import 'package:flutter/material.dart';
import 'models/add_Event.dart';
import 'package:enavit/pages/Intro_page.dart';

void main() {
  runApp(const Enavit());
}

class Enavit extends StatelessWidget {
  const Enavit({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddEvent(),
      child: MaterialApp(
        title: 'Enavit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const IntroPage(),
      ),
    );
  }
}


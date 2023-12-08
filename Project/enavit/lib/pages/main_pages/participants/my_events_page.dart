import 'package:flutter/material.dart';
import 'package:enavit/components/date_picker.dart';
import 'package:enavit/components/event_timeline.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 100,
              child: DatePicker()),
            SizedBox(
              height: 20,
            ),
            EventTimeline(),
          ],
        ),
      ),
    );
  }
}

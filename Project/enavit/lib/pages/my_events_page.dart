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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('My Events'),
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            DatePicker(),
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

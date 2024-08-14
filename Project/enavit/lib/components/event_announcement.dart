import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';

class EventAnnouncement extends StatefulWidget {
  final Event event;
  const EventAnnouncement({super.key, required this.event});
  @override
  State<EventAnnouncement> createState() => _EventAnnouncementState();
}

class _EventAnnouncementState extends State<EventAnnouncement> {
  

  @override
  void initState() {
    super.initState();
 }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPrefs() async {  

    // print(userEvent);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Center(
              child: Text(
                  'An error occurred!')); // Show error message if any error occurs
        } else {
          return const Scaffold();
        }
      },
    );
  }
}

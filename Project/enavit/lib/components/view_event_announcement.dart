import 'package:enavit/components/Event_announcement_tile.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';

class EventAnnouncement extends StatefulWidget {
  final Event event;
  const EventAnnouncement({super.key, required this.event});

  @override
  State<EventAnnouncement> createState() => _EventAnnouncementState();
}

class _EventAnnouncementState extends State<EventAnnouncement> {
  List<EventAnnoucenments> announcements = [];

  @override
  void initState() {
    super.initState();
    // Initialize your announcements list with data here
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPrefs() async {
    // Perform any async initialization here

    Services services = Services();
    announcements = await services.getEventAnnouncements(widget.event.eventId);
    print(announcements);
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
          return Scaffold(
            appBar: AppBar(
              title: const Text("Event Announcements"),
            ),
            body: ListView.builder(
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return AnnouncementTile(
                  announcement: announcement,
                );
              },
            ),
          );
        }
      },
    );
  }
}

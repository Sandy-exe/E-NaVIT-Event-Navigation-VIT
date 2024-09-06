// announcement_tile.dart

import 'package:flutter/material.dart';
import 'package:enavit_main/models/og_models.dart';

import 'package:timeago/timeago.dart' as timeago;

class AnnouncementTile extends StatelessWidget {
  final EventAnnoucenments announcement;

  const AnnouncementTile({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement
                  .eventName, // Assuming eventId is the event name, adjust as needed
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              announcement.announcement, // Announcement text
              style: const TextStyle(
                color: Color.fromARGB(255, 70, 70, 70), // Slightly grey color
                fontSize: 16.0, // Smaller text size
              ), // Adjust the font size as needed
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  announcement.userName, // User ID (name)
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  timeago.format(announcement.dateTime), // Date and time
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:enavit_main/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/models/notify.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<BellNotification> notifications;

  @override
  void initState() {
    super.initState();
    checkForNotification();
  }

  void checkForNotification() async {
    NotificationService service = NotificationService();
    notifications = await service.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.content),
            subtitle: Text(notification.time.toDate().toString()),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(notification.profilePic),
            ),
          );
        },
      ),
    );
  }
}

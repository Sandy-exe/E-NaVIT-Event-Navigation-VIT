import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/notify.dart';
import 'dart:convert';
import 'package:enavit/Data/secure_storage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static SecureStorage secureStorage = SecureStorage();

  Future<List<BellNotification>> getNotifications() async {
    List<BellNotification> notifications = [];
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    List<dynamic> notificationsList =
        jsonDecode(currentUserData['notifications']);
    notifications.addAll(notificationsList
        .map((notification) => BellNotification.fromJson(notification))
        .toList());
    notifications.sort((a, b) => b.time.toDate().compareTo(a.time.toDate()));
    return notifications;
  }

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');

    if (receivedNotification.title == null ||
        receivedNotification.body == null ||
        receivedNotification.createdDate == null) {
      return;
    }

    BellNotification bellNotification = BellNotification(
      name: receivedNotification.title ?? '',
      profilePic: '', // Add appropriate value
      content: receivedNotification.body ?? '',
      postImage: '', // Add appropriate value
      time: Timestamp.fromDate(
          receivedNotification.createdDate ?? DateTime.now()),
    );

    // Read the current user's notifications from secure storage
    String? currentUserDataJson =
        await secureStorage.reader(key: "currentUserData");
    if (currentUserDataJson != null) {
      Map<String, dynamic> currentUserData = jsonDecode(currentUserDataJson);
      List<dynamic> notificationsList =
          jsonDecode(currentUserData['notifications']);

      // Add the new notification to the list
      notificationsList.add(bellNotification.toJson());

      // Write the updated list back to secure storage
      currentUserData['notifications'] = jsonEncode(notificationsList);
      await secureStorage.writer(
          key: "currentUserData", value: jsonEncode(currentUserData));
    }
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      // MainApp.navigatorKey.currentState?.push(
      //   MaterialPageRoute(
      //     builder: (_) => const SecondScreen(),
      //   ),
      // );
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}

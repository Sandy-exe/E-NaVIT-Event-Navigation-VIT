import 'dart:convert';


import 'package:enavit/components/approver_event_search_model.dart';
import 'package:enavit/components/approver_search_model.dart';
import 'package:enavit/components/compute.dart';
import 'package:enavit/components/home_search_model.dart';
import 'package:enavit/pages/main_pages/approvers/approver_set_role_page.dart';
import 'package:enavit/services/firebase_api.dart';
import 'package:enavit/services/local_notification.dart';
import 'package:enavit/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:enavit/Data/secure_storage.dart';

import 'package:enavit/pages/main_pages/general_pages/intro_page.dart';
import 'package:enavit/pages/authentication/login_signup_page.dart';
import 'package:enavit/pages/authentication/signup_page.dart';
import 'package:enavit/pages/main_pages/participants/participant_index_page.dart';
import 'package:enavit/pages/main_pages/participants/participant_profile_page.dart';
import 'package:enavit/pages/main_pages/participants/participant_update_profile_page.dart';
import 'package:enavit/pages/main_pages/organisers/organiser_index_page.dart';
import 'package:enavit/pages/main_pages/organisers/organiser_profile_page.dart';
import 'package:enavit/pages/main_pages/organisers/organiser_update_profile_page.dart';
import 'package:enavit/pages/main_pages/approvers/approver_index_page.dart';
import 'package:enavit/pages/main_pages/approvers/approver_profile_page.dart';
import 'package:enavit/pages/main_pages/approvers/approver_update_profile_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'pages/main_pages/organisers/organiser_approval_creation_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  //await AndroidAlarmManager.initialize();
  SecureStorage securestorage = SecureStorage();
  // await DBSql.initDb();
  // await GetStorage.init();
  
  // NotificationService().initialiseNotifications();

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
          storageBucket: "e-navit.appspot.com",
          projectId: "e-navit"));

  // await FirebaseApi().initNotifications();

  String currentUserDataString =
      await securestorage.reader(key: "currentUserData") ?? "null";

  int userRole = -1;
  if (currentUserDataString != "null") {
    Map<String, dynamic> currentUserData =
        jsonDecode(currentUserDataString); //null not checked properly
    userRole = currentUserData["role"];
  }

//   tz.initializeTimeZones();

// // Testing local notifs
//   NotificationService().sendNotification("vrv", "Vervr");
//   NotificationService().scheduleNotification("test", "vody", DateTime.now());

  print(userRole);

  runApp(

    Enavit(isLoggedIn: isLoggedIn, userRole: userRole),
  );
}

class Enavit extends StatefulWidget {
  final bool isLoggedIn;
  final int userRole;

  const Enavit({super.key, required this.isLoggedIn, required this.userRole});

  @override
  EnavitState createState() => EnavitState();
}

class EnavitState extends State<Enavit> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  @override
  void initState() {
    super.initState();
  }

  listenToNotification(){
    print("listening to notifications");
    LocalNotification.onClickNotification.listen((event) {
      print("Notification clicked");
      print(event);
      // you can set the route to navigate to based on the payload and navigate to different screens
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Compute>(
          create: (context) => Compute(),
        ),
        ChangeNotifierProvider<SearchModel>(
          create: (context) => SearchModel(),
        ),
        ChangeNotifierProvider<ApproverSearchModel>(
          create: (context) => ApproverSearchModel(),
        ),
        ChangeNotifierProvider<ApproverEventSearchModel>(
          create: (context) => ApproverEventSearchModel(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Enavit',
          initialRoute: widget.isLoggedIn
              ? (widget.userRole == 0
                  ? '/approver_index'
                  : (widget.userRole == 1 ? '/organiser_index' : '/participant_index'))
              : '/',
          //initialRoute: '/',
          routes: {
            // First Screen
            '/': (context) => const IntroPage(),
            // General
            '/login': (context) => const LoginSignupPage(),
            '/signup': (context) => const SignUpPage(),
            //participants
            '/participant_index': (context) => const IndexPage(),
            '/participant_profile': (context) => const ProfilePage(),
            '/participant_update_profile': (context) => const UpdateProfile(),
            //organisers
            '/organiser_index': (context) => const OIndexPage(),
            '/organiser_profile': (context) => const OProfilePage(),
            '/organiser_update_profile': (context) =>
                const OProfileUpdatePage(),
            //approvers
            '/approver_index': (context) => const AIndexPage(),
            '/approver_profile': (context) => const AProfilePage(),
            '/approver_update_profile': (context) => const AProfileUpdatePage(),
            '/set_role': (context) => const SetRole(),
            '/event_creation': (context) => const EventCreationPage(),
          }),
    );
  }
}
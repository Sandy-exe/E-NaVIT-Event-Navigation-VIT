import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:enavit_main/components/approver_event_search_model.dart';
import 'package:enavit_main/components/approver_search_model.dart';
import 'package:enavit_main/components/compute.dart';
import 'package:enavit_main/components/home_search_model.dart';
import 'package:enavit_main/pages/main_pages/approvers/approver_SetRole_Button_Index.dart';
import 'package:enavit_main/pages/main_pages/general_pages/approver_set_role_event_organiser_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/edit_my_club_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/notification_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/Captain_set_role_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/view_following_club_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/view_liked_events_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/view_organized_events_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/my_club_page.dart';
import 'package:enavit_main/pages/main_pages/participants/leader_board_page.dart';
import 'package:enavit_main/services/notification_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/Data/secure_storage.dart';

import 'package:enavit_main/pages/main_pages/general_pages/intro_page.dart';
import 'package:enavit_main/pages/authentication/login_signup_page.dart';
import 'package:enavit_main/pages/authentication/signup_page.dart';
import 'package:enavit_main/pages/main_pages/participants/participant_index_page.dart';
import 'package:enavit_main/pages/main_pages/participants/participant_profile_page.dart';
import 'package:enavit_main/pages/main_pages/participants/participant_update_profile_page.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_index_page.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_profile_page.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_update_profile_page.dart';
import 'package:enavit_main/pages/main_pages/approvers/approver_index_page.dart';
import 'package:enavit_main/pages/main_pages/approvers/approver_profile_page.dart';
import 'package:enavit_main/pages/main_pages/approvers/approver_update_profile_page.dart';
import 'package:provider/provider.dart';

import 'pages/main_pages/Captain/organiser_approval_creation_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await AndroidAlarmManager.initialize();
  SecureStorage securestorage = SecureStorage();
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

  //test different Users
  // userRole = 0;
  //await NotificationService.initializeNotification();

  bool role =
      await securestorage.reader(key: 'roleState') == "true" ? true : false;

//   tz.initializeTimeZones();

// // Testing local notifs
//   NotificationService().sendNotification("vrv", "Vervr");
//   NotificationService().scheduleNotification("test", "vody", DateTime.now());

  runApp(
    Enavit(isLoggedIn: isLoggedIn, userRole: userRole, role: role),
  );
}

class Enavit extends StatefulWidget {
  final bool isLoggedIn;
  final int userRole;
  final bool role;

  const Enavit(
      {super.key,
      required this.isLoggedIn,
      required this.userRole,
      required this.role});

  @override
  EnavitState createState() => EnavitState();
}

class EnavitState extends State<Enavit> {
  @override
  void initState() {
    super.initState();
    checkNotificationPermission();
  }

  Future<void> checkNotificationPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
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
                  : ((widget.userRole == 1 || widget.userRole == 4) &&
                          widget.role
                      ? '/organiser_index'
                      : '/participant_index'))
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

            //General Pages
            '/Liked_events': (context) => const LikedEvents(),
            '/Following_clubs': (context) => const FollowedClubs(),
            '/Notification_page': (context) => const NotificationPage(),
            '/Organized_events': (context) => const OrganizedEvents(),
            '/My_club': (context) => const MyClubBio(),
            '/organiser_setRole': (context) => const SetRoleOrganiser(),
            '/LeaderBoard': (context) => const LeaderBoardPage(
                  title: 'Leader Board',
                ),

            //Captain
            '/captain_setRole': (context) => const SetRoleCaptain(),

            //organisers
            '/organiser_index': (context) => const OIndexPage(),
            '/organiser_profile': (context) => const OProfilePage(),
            '/organiser_update_profile': (context) =>
                const OProfileUpdatePage(),

            //approvers
            '/approver_index': (context) => const AIndexPage(),
            '/approver_profile': (context) => const AProfilePage(),
            '/approver_update_profile': (context) => const AProfileUpdatePage(),
            '/set_role_index': (context) => const SetRoleButtonIndexPage(),
            '/event_creation': (context) => const EventCreationPage(),
          }),
    );
  }
}

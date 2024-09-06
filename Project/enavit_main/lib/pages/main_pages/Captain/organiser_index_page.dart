import 'dart:convert';

import 'package:enavit_main/Data/secure_storage.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_approval_publish_page.dart';
import 'package:enavit_main/pages/main_pages/general_pages/my_club_page.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/components/organiser_bottom_nav_bar.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_profile_page.dart';
import 'package:enavit_main/services/authentication_service.dart';
import 'package:enavit_main/pages/main_pages/general_pages/home_page.dart';

class OIndexPage extends StatefulWidget {
  const OIndexPage({super.key});

  @override
  State<OIndexPage> createState() => _OIndexPageState();
}

class _OIndexPageState extends State<OIndexPage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();
  late final bool isLoggedIn;
  int selectedIndex = 0;
  int userRole = -1;

  List<Widget> pages = [];
  List<String> pageTitles = [];

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();

    isLoggedIn = await secureStorage.reader(key: 'isLoggedIn') == 'true';

    if (isLoggedIn) {
      String? currentUserDataString =
          await secureStorage.reader(key: "currentUserData");
      if (currentUserDataString != null) {
        userRole = jsonDecode(currentUserDataString)['role'];
      }
    }

    if (userRole == 1) {
      pages = [
        const HomePage(),
        const OrganiserEventCreationOptionsPage(),
        const MyClubBio(),
        const OProfilePage(),
      ];

      pageTitles = [
        'Home',
        'Event Creation',
        'My Club',
        'Profile',
      ];
    } else if (userRole == 4) {
      pages = [
        const HomePage(),
        const MyClubBio(),
        const OProfilePage(),
      ];

      pageTitles = [
        'Home',
        'My Club',
        'Profile',
      ];
    }

    setState(() {}); // Update the state after initializing preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: NavBar(
        onTabChange: (index) => navigateBottomBar(index),
        userRole: userRole,
      ),
      appBar: AppBar(
        title: Text(pageTitles.isNotEmpty ? pageTitles[selectedIndex] : ''),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/Notification_page');
          //     },
          //     icon: const Icon(
          //       Icons.notifications,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                //logo
                DrawerHeader(
                    child: SizedBox(
                  height: 700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add some spacing between the text and the image
                      Flexible(
                        child: Image.asset(
                          'lib/images/Enavit_logo1.png',
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                )),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Divider(
                //     color: Colors.grey[400],
                //     thickness: 1,
                //   ),
                // ),
                //other pages
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      'About',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.feedback,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      'FeedBack',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: GestureDetector(
                onTap: () {
                  _firebaseAuth.signOut(context);
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: pages.isNotEmpty ? pages[selectedIndex] : Container(),
    );
  }
}

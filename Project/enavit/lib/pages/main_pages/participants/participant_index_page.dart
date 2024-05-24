
import 'package:flutter/material.dart';
import '../../../components/participant_bottom_nav_bar.dart';
import 'package:enavit/pages/main_pages/participants/participant_profile_page.dart';
import 'leader_board_page.dart';
import '../general_pages/home_page.dart';
import 'my_events_page.dart';
import 'package:enavit/services/authentication_service.dart';


class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  final AuthenticationService _firebaseAuth = AuthenticationService();

  int selectedIndex = 0 ;

  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  //pages to display
  final List<Widget> pages = [
    const HomePage(),
    const MyEvents(),
    const LeaderBoardPage(),
    const ProfilePage(),
  ];

  final List<String> pageTitles = [
    'Home',
    'My Events',
    'Leader Board',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: NavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex]),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Padding(
                padding:  EdgeInsets.only(left: 25.0),
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  ),
              ),
            ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Notification_page');
              },
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                 //logo
                DrawerHeader(
                  child: SizedBox(
                    height: 500,
                    child: Column(
                      children: [
                        const Center(child: Text("Enavit"
                      ,style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        ),)),
                        Image.asset(
                          'lib/images/Denji.jpg',
                          width: 150,
                          ),
                      ],
                    ),
                  ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  ),
                  
                  //other pages
                  const Padding(
                    padding: EdgeInsets.only(left:25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                        ),
                      title: Text(
                        'home',
                        style: TextStyle(color: Colors.white),
                      ),
                      ),
                    ),

                  const Padding(
                    padding: EdgeInsets.only(left:25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.white,
                        ),
                      title: Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                      ),
                    ),

                    const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Request Approver',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ), 
              
              Padding(
                padding: const EdgeInsets.only(left:25.0,bottom: 25.0),
                child: GestureDetector(
                  onTap: () {
                    _firebaseAuth.signOut(context);
                  },
                  child:  const ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                      ),
                    title: Text(
                      'logout',
                      style: TextStyle(color: Colors.white),
                    ),
                        ),
                ),
              ),
          ]
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}

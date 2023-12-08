
import 'package:flutter/material.dart';
import '../../../components/approver_bottom_nav_bar.dart';
import 'package:enavit/pages/main_pages/approvers/approver_profile_page.dart';
import 'package:enavit/services/authentication_service.dart';
import 'package:enavit/pages/main_pages/general_pages/home_page.dart';


class AIndexPage extends StatefulWidget {
  const AIndexPage({super.key});

  @override
  State<AIndexPage> createState() => _AIndexPageState();
}

class _AIndexPageState extends State<AIndexPage> {

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
    const AProfilePage(),
  ];

  final List<String> pageTitles = [
    'Home',
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
                  child: Image.asset(
                    'lib/images/Denji.jpg',
                    height: 300,
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0),
                  child: Divider(
                    color: Colors.grey[400],
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

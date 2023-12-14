import 'dart:convert';

import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AProfilePage extends StatefulWidget {
  const AProfilePage({super.key});

  @override
  State<AProfilePage> createState() => _AProfilePageState();
}

class _AProfilePageState extends State<AProfilePage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();

  late bool isLoggedIn;
  late Map<String, dynamic> currentUserData;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();

    isLoggedIn = await secureStorage.reader(key: 'isLoggedIn') == 'true';

    if (isLoggedIn) {
      String? currentUserDataString =
          await secureStorage.reader(key: "currentUserData");
      if (currentUserDataString != null) {
        currentUserData = jsonDecode(currentUserDataString);
      }
    }
    if (currentUserData['role'] == '0') {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/participant_index", (r) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //var isDark = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder(
        future: initPrefs(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[300],
              body: SingleChildScrollView(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 10, left: 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/images/VIT_LOGO.png')),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/participant_update_profile');
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.pencil,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              currentUserData['name'] ?? 'Name not found',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            currentUserData['email'] ?? 'Email not found',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              height: 0.8,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/participant_update_profile');
                              },
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Divider(),
                          const SizedBox(height: 15),
                          ProfileMenuWidget(
                            text: 'Set Roles',
                            icon: Icons.group,
                            onTap: () {
                              Navigator.pushNamed(context, '/set_role');
                            },
                          ),
                          ProfileMenuWidget(
                            text: 'Settings',
                            icon: FontAwesomeIcons.gear,
                            onTap: () {
                              _firebaseAuth.signOut(context);
                            },
                          ),
                          const SizedBox(height: 15),
                          ProfileMenuWidget(
                            text: 'Log Out',
                            icon: FontAwesomeIcons.powerOff,
                            onTap: () {
                              _firebaseAuth.signOut(context);
                            },
                          ),
                        ],
                      ))),
            );
          }
        });
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const ProfileMenuWidget({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
      leading: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  FontAwesomeIcons.angleRight,
                  size: 15,
                  color: Colors.black,
                ),
              ),
            ));
}

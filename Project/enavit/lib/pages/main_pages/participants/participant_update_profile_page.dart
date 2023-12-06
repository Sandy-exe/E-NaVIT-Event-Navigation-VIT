import 'dart:convert';

import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enavit/Data/secure_storage.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _mobileTEC = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
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
                appBar: AppBar(
                  backgroundColor: Colors.grey[300],
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Center(child: Text('Edit Profile')),
                ),
                body: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(20),
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
                                            'lib/images/Pochita.jpg')),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 10,
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.camera,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Form(
                                child: Column(
                              children: [
                                TextFormField(
                                  controller: _name,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.user),
                                    labelText: currentUserData['name'],
                                    hintText: "Enter new name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailTEC,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.envelope),
                                    labelText: currentUserData['email'],
                                    hintText: "Enter new email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _mobileTEC,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.phone),
                                    labelText: currentUserData['phone_no'],
                                    hintText: "Enter new phone number",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    onPressed: () {
                                      updateprof();
                                    },
                                    child: const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ))));
          }
        });
  }
  

  void updateprof() async {
    final String email = _emailTEC.text.isEmpty? currentUserData['email']: _emailTEC.text;
    final String phoneno = _mobileTEC.text.isEmpty? currentUserData['phone_no']: _mobileTEC.text;
    final String name = _name.text.isEmpty? currentUserData['name']: _name.text;

    Map<String, dynamic> newinfo = {
      "email": email,
      "phone_no": phoneno,
      "name": name,
    };

    currentUserData['email'] = email;
    currentUserData['phone_no'] = phoneno;
    currentUserData['name'] = name;
    SecureStorage secureStorage = SecureStorage();
    String newUserDataString = jsonEncode(currentUserData);
    await secureStorage.writer(
        key: "currentUserData", value: newUserDataString);

    Services  services = Services();
    services.updateUser(currentUserData['userid'],newinfo);

    if (context.mounted) Navigator.pushNamed(context, '/participant_profile'); 
    
  }

}

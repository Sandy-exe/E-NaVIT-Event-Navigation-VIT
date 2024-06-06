import 'dart:convert';

import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enavit/services/services.dart';

class ViewProfile extends StatefulWidget {
  final Users user;  
  const ViewProfile({super.key, required this.user});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  late Map<String,dynamic> currentUserData = {};

  @override
  void initState() {
    super.initState();
    initPrefs();  
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();
    currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

  }

  Future RemovefromClub() async {
    Services service = Services();

    Map<String, dynamic> newinfo = {
      'clubIds': [],
      'clubs' : [],
      'role' : 2
    };
    await service.updateUser(widget.user.userId, newinfo);

    print("Removed from Club");
    Navigator.pushNamed(context, '/set_role');
  }
  
  Future AddToClub() async {
    
    Services service = Services();
    
    Map<String, dynamic> newinfo = {'clubIds': currentUserData['clubIds'], 'clubs': currentUserData['clubIds'], 'role': 1};
    await service.updateUser(widget.user.userId, newinfo);
    print("Added to Club");
    
    Navigator.pushNamed(context, '/set_role');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
  future: initPrefs(), // replace with your function to fetch user data
  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Profile"),
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 22),
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
                        child: Image.network(
                          widget.user.profileImageURL =="null" ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png' :  widget.user.profileImageURL, 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    height: 0.8,
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 15),
                Text(
                  'Role: ${widget.user.role == 1 ? 'Organizer' : 'Participant'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 15),
                widget.user.role == 1 ? Text(
                  'Club ID: ${widget.user.clubIds.isEmpty ? 'NOCLUB' : widget.user.clubIds[0]}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ) : const SizedBox(),


                const SizedBox(height: 15),

                currentUserData['clubIds'].contains(widget.user.clubIds.isEmpty ? 'NOCLUB' : widget.user.clubIds[0] ) && widget.user.role == 1 ? 
                ElevatedButton(onPressed:  () {
                  RemovefromClub();
                }, 
                child: const Text("Remove from Club")) 
                : 
                widget.user.role == 2 ? 
                ElevatedButton(onPressed:  () {
                  AddToClub();
                },
                child: const Text("Add to Club")) 
                :
                const SizedBox(),
                
              ],
            ),
          ),
        ),
      );
    }
  },
);
  }
}
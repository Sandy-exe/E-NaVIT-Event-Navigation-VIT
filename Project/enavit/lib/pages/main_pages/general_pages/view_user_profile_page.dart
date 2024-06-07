import 'dart:convert';

import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enavit/services/services.dart';

class ViewProfile extends StatefulWidget {
  final Users user;
  final String setType;  
  const ViewProfile({super.key, required this.user, required this.setType});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  late Map<String,dynamic> currentUserData = {};
  late Club ClubData;
  late List<Event> events = [];

  @override
  void initState() {
    super.initState();
    initPrefs();  
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();
    currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    Services service = Services();
    ClubData = await service.getClubData(currentUserData['clubIds'][0]);
    events = await service.getClubEvents(ClubData.clubId);    
  
  }

  Future removefromOrganiser() async {
    Services service = Services();

    Map<String, dynamic> newinfo = {
      'clubIds': [],
      'clubs' : [],
      'role' : 2
    };
    await service.updateUser(widget.user.userId, newinfo);

    print("Removed from Club");
    Navigator.pushNamed(context, '/set_role_index');
  }
  
  Future addtoOrganiser() async {
    Services service = Services();
    Map<String, dynamic> newinfo = {'clubIds': currentUserData['clubIds'], 'clubs': currentUserData['clubIds'], 'role': 1};
    await service.updateUser(widget.user.userId, newinfo);
    print("Added to Club");
    Navigator.pushNamed(context, '/set_role_index');
  }

  Future setCaptain() async {
    Services service = Services();
  
    Map<String, dynamic> newinfoUser = {
      'clubIds': currentUserData['clubIds'],
      'clubs': currentUserData['clubIds'],
      'role': 1
    };

    List<String> approvers = List<String>.from(ClubData.approvers);
    if (approvers.length == 1) {
      approvers.add("null");
      approvers[1] = widget.user.userId;
    } else {
      approvers[1] = widget.user.userId;
    }

    Map<String,dynamic> newinfoClub = {
      'approvers' : approvers
    };

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateClub(ClubData.clubId, newinfoClub);
    print("Set as Captain");
    
    Navigator.pushNamed(context, '/captain_setRole');
    
  }

  Future removeCaptain() async {
    
    Services service = Services();

    Map<String, dynamic> newinfoUser = {
      'clubIds': [],
      'clubs': [],
      'role': 3
    };

    List<String> approvers = List<String>.from(ClubData.approvers);
    approvers[1] = "null";

    Map<String, dynamic> newinfoClub = {'approvers': approvers};

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateClub(ClubData.clubId, newinfoClub);
    print("Remove as Captain");
    Navigator.pushNamed(context, '/captain_setRole');
  }

  Future addClubMember() async {
    Services service = Services();
    Map<String, dynamic> newinfo = {'role': 1};
    await service.updateUser(widget.user.userId, newinfo);
    print("Added as Club Member");
    Navigator.pushNamed(context, '/set_role_index');
  }

  Future removeClubMember() async {
    Services service = Services();
    Map<String, dynamic> newinfo = {'role': 3};
    await service.updateUser(widget.user.userId, newinfo);
    print("Removed as Club Member");
    Navigator.pushNamed(context, '/set_role_index');
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
                  'Role: ${widget.user.role == 1 ? 'Captain/Memeber' : widget.user.role == 2 ? 'Organised Events' : 'Participant' }',
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

                currentUserData['clubIds'].contains(widget.user.clubIds.isEmpty ? 'NOCLUB' : widget.user.clubIds[0] ) && widget.user.role == 1 && widget.setType == "Set Captain" ? 
                ElevatedButton(onPressed:  () {

                  removeCaptain();
                  
                }, 
                child: const Text("Remove as Captain")) 
                : 
                ((widget.user.role == 2 || widget.user.role == 3) && ClubData.approvers[1] == "null" && widget.setType == "Set Captain")  ? 
                ElevatedButton(onPressed:  () {
                  setCaptain();
                },
                child: const Text("Set as Captain")) 
                :
                const SizedBox(),

                !(currentUserData['clubIds'].contains(widget.user.clubIds.isEmpty ? 'NOCLUB' : widget.user.clubIds[0] ) ) && (widget.user.role == 3 || widget.user.role == 2) && widget.setType == "Set Event Organiser" 
                ?
                ElevatedButton(onPressed:  () {
                  print("create new page for organiser");
                },
                child: const Text("Add as organiser to an Event"))
                :

                events.toSet().intersection(widget.user.organizedEvents.toSet()).isNotEmpty ?
                ElevatedButton(onPressed:  () {
                  print("remvove from organiser");
                },
                child: const Text("Remove Event from Organiser"))

                : 
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 50,
                ),


                
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
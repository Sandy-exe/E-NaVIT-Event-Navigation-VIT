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
  late Map<String, dynamic> currentUserData = {};
  late Club ClubData;
  late List<Event> events = [];

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void dispose() {
    super.dispose();
  }

  Future showMyRemoveOrganiserDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //checking organised events to remove
        List<String> OrganizedeventIds = widget.user.organizedEvents;

        Map<String, String> eventIdToName = {
          for (var event in events) event.eventId: event.eventName
        };

        List<String> eventIds = eventIdToName.keys
            .toList()
            .toSet()
            .intersection(OrganizedeventIds.toSet())
            .toList();

        if (eventIds.isEmpty) eventIds.add("No Event");

        String dropdownValue = eventIds[0]; // Default value for dropdown
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Event to Remove'),
              content: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: eventIds.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(eventIdToName[value] ?? "Error"),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    removefromOrganiser(dropdownValue);
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future showMyAddOrganiserDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<String, String> eventIdToName = {
          for (var event in events) event.eventId: event.eventName
        };

        List<String> eventIds = eventIdToName.keys.toList();
        List<String> organisedEvents = widget.user.organizedEvents;

        eventIds =
            eventIds.toSet().difference(organisedEvents.toSet()).toList();

        if (eventIds.isEmpty) eventIds.add("No Event");

        String dropdownValue = eventIds[0]; // Default value for dropdown
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select a Event'),
              content: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: eventIds.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(eventIdToName[value] ?? "Error"),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    addtoOrganiser(dropdownValue);
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();
    currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");

    Services service = Services();
    ClubData = await service.getClubData(currentUserData['clubIds'][0]);    

    events = await service.getClubEvents(ClubData.clubId);

    print(ClubData.approvers);

    
  }

  Future removefromOrganiser(String eventId) async {
    Services service = Services();

    List<String> organizedEvents =
        List<String>.from(widget.user.organizedEvents);

    organizedEvents.remove(eventId);

    Map<String, dynamic> newinfoUser = {};

    if (organizedEvents.isEmpty) {
      newinfoUser = {'organized_events': organizedEvents, 'role': 3};
    } else {
      newinfoUser = {'organized_events': organizedEvents, 'role': 2};
    }

    List<String> organisers = List<String>.from(
        events.firstWhere((element) => element.eventId == eventId).organisers);
    organisers.remove(widget.user.userId);
    Map<String, dynamic> newinfoEvent = {'organisers': organisers};

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateEvent(eventId, newinfoEvent);
    print("Removed as Organiser");
    
    
    if (currentUserData['role'] == 0) {Navigator.pop(context); // Pop the last route
  Navigator.pop(context);
Navigator.pop(context);
      Navigator.pushNamed(context, '/set_role_index');
    } else {
      Navigator.pushNamed(context, '/organiser_setRole');
    }
  }

  Future addtoOrganiser(String eventId) async {
    Services service = Services();

    List<String> organizedEvents =
        List<String>.from(widget.user.organizedEvents);
    organizedEvents.add(eventId);

    Map<String, dynamic> newinfoUser = {
      'organized_events': organizedEvents,
      'role': 2
    };

    List<String> organisers = List<String>.from(
        events.firstWhere((element) => element.eventId == eventId).organisers);
    organisers.add(widget.user.userId);
    Map<String, dynamic> newinfoEvent = {'organisers': organisers};
    await service.updateUser(widget.user.userId, newinfoUser);

    await service.updateEvent(eventId, newinfoEvent);
    print("Added as organiser");


    
    if (currentUserData['role'] == 0) {Navigator.pop(context); // Pop the last route
  Navigator.pop(context);
Navigator.pop(context);
      Navigator.pushNamed(context, '/set_role_index');
    } else {
      Navigator.pushNamed(context, '/organiser_setRole');
    }
  }

  Future setCaptain() async {
    Services service = Services();



    Map<String, dynamic> newinfoUser = {
      'clubIds': currentUserData['clubIds'],
      'clubs': currentUserData['clubIds'],
      'role': 1
    };

    List<String> approvers = List<String>.from(ClubData.approvers);
    print("approvers");
    if (approvers.length == 1) {
      approvers.add("null");
      approvers[1] = widget.user.userId;
    } else {
      approvers[1] = widget.user.userId;
    }

    Map<String, dynamic> newinfoClub = {'approvers': approvers};

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateClub(ClubData.clubId, newinfoClub);
    print("Set as Captain");

    
    if (currentUserData['role'] == 0) {Navigator.pop(context); // Pop the last route
  Navigator.pop(context);
Navigator.pop(context);
      Navigator.pushNamed(context, '/set_role_index');
    } else {
      Navigator.pushNamed(context, '/captain_setRole');
    }
  }

  Future removeCaptain() async {
    Services service = Services();

    int role = 3;

    if (widget.user.organizedEvents.isNotEmpty) {
      role = 2;
    }

    Map<String, dynamic> newinfoUser = {'clubIds': [], 'clubs': [], 'role': role};

    List<String> approvers = List<String>.from(ClubData.approvers);
    approvers[1] = "null";

    Map<String, dynamic> newinfoClub = {'approvers': approvers};

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateClub(ClubData.clubId, newinfoClub);
    print("Remove as Captain");
    
    if (currentUserData['role'] == 0) {Navigator.pop(context); // Pop the last route
  Navigator.pop(context);
Navigator.pop(context);
      Navigator.pushNamed(context, '/set_role_index');
    } else {
      Navigator.pushNamed(context, '/captain_setRole');
    }
  }


  Future addClubMember() async {
    
    Services service = Services();
    

    Map<String, dynamic> newinfoUser = {
      'clubIds': currentUserData['clubIds'],
      'clubs': currentUserData['clubIds'],
      'role': 1
    };

    List<String> approvers = List<String>.from(ClubData.approvers);

    approvers.add(widget.user.userId);

    Map<String, dynamic> newinfoClub = {'approvers': approvers};

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateClub(ClubData.clubId, newinfoClub);
    print("Set as Club Member");

    if (currentUserData['role'] == 0) {Navigator.pop(context); // Pop the last route
  Navigator.pop(context);
Navigator.pop(context);
      Navigator.pushNamed(context, '/set_role_index');
    } else {
      Navigator.pushNamed(context, '/organiser_setRole');
    }
    

  }

  Future removeClubMember() async {
    Services service = Services();

    int role = 3;

    if (widget.user.organizedEvents.isNotEmpty) {
      role = 2;
    }

    Map<String, dynamic> newinfoUser = {'clubIds': [], 'clubs': [], 'role': role};

    List<String> approvers = List<String>.from(ClubData.approvers);
    
    approvers.remove(widget.user.userId);

    Map<String, dynamic> newinfoClub = {'approvers': approvers};

    await service.updateUser(widget.user.userId, newinfoUser);
    await service.updateClub(ClubData.clubId, newinfoClub);
    print("Remove as Club Member");
    
    
    if (currentUserData['role'] == 0) {Navigator.pop(context); // Pop the last route
  Navigator.pop(context);
Navigator.pop(context);
      Navigator.pushNamed(context, '/set_role_index');
    } else {
      Navigator.pushNamed(context, '/organiser_setRole');
    }

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
                              widget.user.profileImageURL == "null" || widget.user.profileImageURL == null
                                  ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
                                  : widget.user.profileImageURL,
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
                      'Role: ${widget.user.role == 1 ? 'Captain/Member' : widget.user.role == 2 ? 'Organised Events' : 'Participant'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    widget.user.role == 1
                        ? Text(
                            'Club ID: ${widget.user.clubIds.isEmpty ? 'NOCLUB' : widget.user.clubIds[0]}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 15),

                    
                    (ClubData.approvers.length == 1)
                        ? ElevatedButton(
                            onPressed: () {
                              setCaptain();
                            },
                            child: const Text("Set as Captain"))
                        :
                   
                   ClubData.approvers[1] == widget.user.userId &&
                            widget.user.role == 1  && currentUserData['role'] == 0 &&
                            widget.setType == "Set Captain"
                        ? ElevatedButton(
                            onPressed: () {
                              removeCaptain();
                            },
                            child: const Text("Remove as Captain"))
                        : ((widget.user.role == 2 || widget.user.role == 3) &&
                                (ClubData.approvers[1] == "null") && currentUserData['role'] == 0 &&
                                widget.setType == "Set Captain")
                            ? ElevatedButton(
                                onPressed: () {
                                  setCaptain();
                                },
                                child: const Text("Set as Captain"))
                            : const SizedBox(),


                    Set<String>.from(ClubData.events)
                                .difference(Set<String>.from(
                                    widget.user.organizedEvents))
                                .isNotEmpty &&
                            (widget.user.role == 3 || widget.user.role == 2) &&
                            widget.setType == "Set Event Organiser"
                        ? ElevatedButton(
                            onPressed: () {
                              showMyAddOrganiserDialog(context);
                            },
                            child: const Text("Add as organiser to an Event"))
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    (Set<String>.from(widget.user.organizedEvents)
                            .intersection(Set<String>.from(ClubData.events))
                            .isNotEmpty) &&
                            (widget.user.role == 3 || widget.user.role == 2) &&
                            widget.setType == "Set Event Organiser"
                        ? ElevatedButton(
                            onPressed: () {
                              showMyRemoveOrganiserDialog(context);
                            },
                            child: const Text("Remove Event from Organiser"))
                        : const SizedBox(),

                      (ClubData.approvers.length == 1) ?
                      const SizedBox()
                        :
                        (widget.user.role == 3 || widget.user.role == 2) && !List<String>.from(ClubData.approvers.sublist(2)).contains(widget.user.userId) ? 
                        ElevatedButton(
                            onPressed: () {
                              addClubMember();
                            },
                            child: const Text("Add as Club Member"))
                        : widget.user.role == 1 && List<String>.from(ClubData.approvers.sublist(2)).contains(widget.user.userId) 
                        ? ElevatedButton(onPressed: () {  

                          removeClubMember();

                        }
                        , child: const Text("Remove as Club Member"))
                        : const SizedBox()

                        
                        



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

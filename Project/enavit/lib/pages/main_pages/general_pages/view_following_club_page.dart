import 'package:enavit/components/club_tile.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';

class FollowedClubs extends StatefulWidget {
  const FollowedClubs({super.key});

  @override
  State<FollowedClubs> createState() => _FollowedClubsState();
}

class _FollowedClubsState extends State<FollowedClubs> {
  late List<Club> followedClubs;
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    print("InitPrefs");
    Services service = Services();
    followedClubs = await service.getFollowedClubs(context);
    print("InitPrefs");
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initPrefs(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.grey[300],
                body: const Center(
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
                    title: const Text("Following Clubs")),
                body: followedClubs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_off,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You are not following any clubs",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: followedClubs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          // get a club
                          Club club = followedClubs[index];
                          return ClubTile(club: club);
                        },
                      ));
          }
        });
  }
}

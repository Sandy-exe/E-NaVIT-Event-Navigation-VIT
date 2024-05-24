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
                  title: const Text("Send Request")),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: followedClubs.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        // get an event
                        Club club = followedClubs[index];
                        return ClubTile(club: club);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

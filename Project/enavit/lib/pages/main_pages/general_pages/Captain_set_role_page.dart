import 'package:enavit/components/approver_search_model.dart';
import 'package:enavit/components/participant_tile.dart';
import 'package:enavit/models/og_models.dart';
import 'package:flutter/material.dart';
import 'package:enavit/services/services.dart';
import 'package:enavit/components/participants_search.dart';
import 'package:provider/provider.dart';

class SetRoleCaptain extends StatefulWidget {
  const SetRoleCaptain({super.key});
  @override
  State<SetRoleCaptain> createState() => _SetRoleCaptainState();
}

class _SetRoleCaptainState extends State<SetRoleCaptain> {
  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    Services service = Services();
    await service.getParticipantData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initPrefs(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.grey[300],
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
                title: const Text("Set Captain Roles"),
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  buildParticipantsSearch(),
                  const FloatingSearchBarWidgetApprover(),
                ],
              ),
            );
          }
        });
  }

  Widget buildParticipantsSearch() {
    return Consumer<ApproverSearchModel>(
        builder: (BuildContext context, value, _) {
      //
      //
      return Column(
        children: [
          //Dummy search bar in Stack
          const SizedBox(
            height: 60,
          ),
          //HOT Picks
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Available Participants',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10.0,
          ),

          //Event user
          Expanded(
            child: ListView.builder(
              itemCount: value.userListApprover.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // get a user
                Users user = value.userListApprover[index];

                return ParticipantTile(user: user, setType: "Set Roles");
              },
            ),
          ),
        ],
      );
    });
  }
}

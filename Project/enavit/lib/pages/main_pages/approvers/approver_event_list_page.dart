
import 'package:enavit/components/approver_event_search.dart';
import 'package:enavit/components/approver_event_search_model.dart';
import 'package:enavit/components/approver_event_tile.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ApproverEvents extends StatefulWidget {
  const ApproverEvents({super.key});

  @override
  State<ApproverEvents> createState() => _ApproverEventsState();
}

class _ApproverEventsState extends State<ApproverEvents> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    Services service = Services();
    await service.getOrganizedEvents(context);
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
              body: Stack(
                fit: StackFit.expand,
                children: [
                  buildParticipantsSearch(),
                  const FloatingSearchBarWidgetApproverEvent(),
                ],
              ),
            );
          }
        });
  }

  Widget buildParticipantsSearch() {
    return Consumer<ApproverEventSearchModel>(
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
                  'Organized Events',
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
              itemCount: value.eventListfinal.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // get a user
                Event event = value.eventListfinal[index];
                return AEventTile(approverEvent: event);
              },
            ),
          ),
        ],
      );
    });
  }
}



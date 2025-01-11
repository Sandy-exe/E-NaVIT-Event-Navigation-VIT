import 'package:enavit/components/event_tile.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';

class organizedEventsParticipant extends StatefulWidget {
  String userid;
  organizedEventsParticipant({super.key, required this.userid});

  @override
  State<organizedEventsParticipant> createState() =>
      _organizedEventsParticipantState();
}

class _organizedEventsParticipantState
    extends State<organizedEventsParticipant> {
  late List<Event> organizedEvents = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    print("oho");
    Services service = Services();
    organizedEvents =
        await service.getOrganizedEventsView(context, widget.userid);
    print("done");
    print(organizedEvents);
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
                  title: const Text("Organized Events")),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  ListView.builder(
                    itemCount: organizedEvents.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      // get an event
                      Event event = organizedEvents[index];
                      return EventTile(event: event);
                    },
                  ),
                ],
              ),
            );
          }
        });
  }
}

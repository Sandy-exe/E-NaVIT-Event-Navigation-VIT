import 'package:enavit_main/components/event_tile.dart';
import 'package:enavit_main/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/models/og_models.dart';

class OrganizedEvents extends StatefulWidget {
  const OrganizedEvents({super.key});

  @override
  State<OrganizedEvents> createState() => _OrganizedEventsState();
}

class _OrganizedEventsState extends State<OrganizedEvents> {
  late List<Event> organizedEvents;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    print("oho");
    Services service = Services();
    organizedEvents = await service.getOrganizedEventsView(context, " ");
    print("done");
    print(organizedEvents);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
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
              title: const Text("Organized Events"),
            ),
            body: Container(
              color: Colors.grey[300],
              child: ListView.builder(
                itemCount: organizedEvents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  // get an event
                  Event event = organizedEvents[index];
                  return EventTile(event: event);
                },
              ),
            ),
          );
        }
      },
    );
  }
}

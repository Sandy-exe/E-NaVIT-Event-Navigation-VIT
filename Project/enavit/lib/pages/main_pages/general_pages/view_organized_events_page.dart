import 'package:enavit/components/event_tile.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';

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
    Services service = Services();
    organizedEvents = await service.getOrganizedEventsView(context);
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
                  title: const Text("Organized Events")),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Expanded(
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
                ],
              ),
            );
          }
        });
  }
}
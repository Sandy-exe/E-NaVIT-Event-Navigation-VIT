import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/components/Event_tile.dart';
import 'package:enavit/models/og_models.dart';

class LikedEvents extends StatefulWidget {
  
  const LikedEvents({super.key});

  @override
  State<LikedEvents> createState() => _LikedEventsState();
}

class _LikedEventsState extends State<LikedEvents> {
  late List<Event> likedEvents;
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    Services service = Services();
    print("oh");
    likedEvents = await service.getLikedEvents(context);
    print("oh");

  }
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
                  title: const Text("Liked Events")),
              body:               likedEvents.isEmpty 
                ?                 const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No Events",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                : // Your code for displaying events :  
                ListView.builder(
                      itemCount: likedEvents.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        // get an event
                        Event event = likedEvents[index];
                        return EventTile(event: event);
                      },
                    ),
                
            );
          }
        });
  }

  }

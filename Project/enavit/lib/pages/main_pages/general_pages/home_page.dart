import 'package:enavit/components/search_model.dart';
import 'package:flutter/material.dart';
import '../../../components/event_tile.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:enavit/components/event_club_search.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List eventList = [];
  late int eventListLength;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    Services service = Services();
    eventList = await service.getEventClubData(context);
  }

  void addEventToUser(Event event) {
    // get a Event from Event list
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Successfully Added'),
        content:
            Text('You have successfully added ${event.eventName} to your list'),
      ),
    );
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
            return Stack(
              fit: StackFit.expand,
              children: [
                buildHomepage(),
                const FloatingSearchBarWidget(),
              ],
            );
          }

          //HOT Picks
          //   const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 25.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         Text(
          //           'Available Events',
          //           style: TextStyle(
          //             fontSize: 24.0,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),

          //   const SizedBox(
          //     height: 10.0,
          //   ),

          //   //Event List
          //   Expanded(
          //     child: ListView.builder(
          //       itemCount: eventListLength,
          //       scrollDirection: Axis.vertical,
          //       itemBuilder: (context, index) {
          //         // get a Event from Event list
          //         Event event = eventList[index];
          //         return EventTile(
          //           event: event,
          //           onTap: () => addEventToUser(event),
          //         );
          //       },
          //     ),
          //   ),
          //],
          //);
          //}
          //}
        });
  }

  Widget buildHomepage() {
    return Consumer<SearchModel>(
      builder: (BuildContext context, value, _){
        // 
        // 
        return 
        Column(
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
                  'Available Events',
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

          //Event List
          Expanded(
            child: ListView.builder(
              itemCount: value.eventListHome.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // get a Event from Event list
                Event event = value.eventListHome[index];
                return EventTile(
                  event: event,
                  onTap: () => addEventToUser(event),
                );
              },
            ),
          ),
        ],
        );
  });
  }
}

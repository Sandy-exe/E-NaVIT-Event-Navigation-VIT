import 'package:enavit/components/club_tile.dart';
import 'package:enavit/components/home_search_model.dart';
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
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    
    Services service = Services();
    await service.getEventClubData(context);
    print("oj please?");
    
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
        });
  }

  Widget buildHomepage() {
    return Consumer<SearchModel>(builder: (BuildContext context, value, _) {
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
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 56, 86, 158), // Adjust color if needed
                    letterSpacing:
                        1.2, // Add letter spacing for better readability
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
              itemCount: value.eventClubListHome.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                
                // get a Event from Event list
                Object object = value.eventClubListHome[index];
                print(object);

                if (object is Club) {
                  return ClubTile(
                    club: object,
                  );
                } else {
                  return EventTile(
                    event: object as Event,
                  );
                }
              },
            ),
          ),
        
                ],
      );
    });
  }
}

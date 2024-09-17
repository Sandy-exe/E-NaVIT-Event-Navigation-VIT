import 'package:enavit_main/components/club_tile.dart';
import 'package:enavit_main/components/dean_club_edit_tile.dart';
import 'package:enavit_main/components/home_search_model.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/components/event_tile.dart';
import 'package:enavit_main/models/og_models.dart';
import 'package:enavit_main/services/services.dart';
import 'package:enavit_main/components/event_club_search.dart';
import 'package:provider/provider.dart';

class DeanEditClubPage extends StatefulWidget {
  const DeanEditClubPage({super.key});

  @override
  State<DeanEditClubPage> createState() => _DeanEditClubPageState();
}

class _DeanEditClubPageState extends State<DeanEditClubPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    Services service = Services();
    await service.getClubListData(context);
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
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: const Text("Edit Club"),
              centerTitle: true,
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                buildHomepage(),
                const FloatingSearchBarWidget(), // Search bar floating on top
              ],
            ),
          );
        }
      },
    );
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
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Text(
          //         'Upcoming Events',
          //         style: TextStyle(
          //           fontSize: 20.0,
          //           fontWeight: FontWeight.bold,
          //           color: Color.fromARGB(
          //               255, 56, 86, 158), // Adjust color if needed
          //           letterSpacing:
          //               1.2, // Add letter spacing for better readability
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(
          //   height: 10.0,
          // ),

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
                  return EditClubTile(
                    club: object,
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

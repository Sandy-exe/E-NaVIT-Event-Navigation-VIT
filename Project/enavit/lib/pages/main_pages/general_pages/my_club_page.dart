import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/event_tile.dart';
import 'package:enavit/pages/main_pages/general_pages/edit_my_club_page.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enavit/components/flutter_flow_theme.dart';
import 'package:enavit/models/og_models.dart';

class MyClubBio extends StatefulWidget {
  const MyClubBio({super.key});

  @override
  State<MyClubBio> createState() => _MyClubBioState();
}

class _MyClubBioState extends State<MyClubBio> {
  late List<dynamic> eventList = [];
  late double eventListLength;
  late Club club = Club(
      approvers: List.empty(),
      clubName: "VIT",
      clubId: "1",
      bio: "VIT is a club",
      email: "sfd@sdf.com",
      events: List.empty(),
      followers: List.empty());

  bool isFollow = false; //random

  void toggleFollow() async {
    Services services = Services();
    bool newFollowStatus = await services.toggleFollowClubs(club.clubId);
    setState(() {
      isFollow = newFollowStatus;
    });
  }

  Future<void> initPrefs() async {
    Services service = Services();
    club = await service.getOrganizerClubDetails();
    eventList = await service.getClubEvents(club.clubId);
    print(eventList.length);
    eventListLength = 600*eventList.length.toDouble();
    print(eventListLength);
    isFollow = await service.checkFollowClub(club.clubId);
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
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    image: DecorationImage(
                      image: AssetImage('lib/images/Campus_vitchennai.jpg'),
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Center(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 150, 0, 0),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(224, 224, 224, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              
                              //mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'lib/images/VIT_LOGO.png',
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    35, 40, 0, 0),
                                            child: FaIcon(
                                              FontAwesomeIcons.solidCircle,
                                              color: Color(0xFF27DA3E),
                                              size: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 0, 0),
                                                  child: Container(
                                                    width: 70,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '604',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText1,
                                                        ),
                                                        Text(
                                                          'Events',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: const Color(
                                                                        0xFFB3B3B3),
                                                                    fontSize: 8,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 0, 0),
                                                  child: Container(
                                                    width: 70,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '705k',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText1,
                                                        ),
                                                        Text(
                                                          'Followers',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: const Color(
                                                                        0xFFB3B3B3),
                                                                    fontSize: 8,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 0, 0),
                                                  child: Container(
                                                    width: 70,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '12',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText1,
                                                        ),
                                                        Text(
                                                          'Posts',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: const Color(
                                                                        0xFFB3B3B3),
                                                                    fontSize: 8,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 0, 0),
                                                  child: Container(
                                                    width: 35,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: PopupMenuButton<int>(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                      ),
                                                      color: Colors.white,
                                                      icon: const Icon(
                                                        Icons.more_horiz,
                                                        color: Color(0xFF333333),
                                                        size: 20,
                                                      ),
                                                      itemBuilder: (context) => [
                                                        const PopupMenuItem(
                                                          value: 1,
                                                          child: Text("Edit Profile"),
                                                        ),
                                                        const PopupMenuItem(
                                                          value: 2,
                                                          child: Text("View Stats"),
                                                        ),
                                                      ],
                                                      onSelected: (value) {
              
                                                        if (value == 1) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditMyClub(club: club),
                                                            ),
                                                          );
                                                        }
              
                                                        if (value == 2) {
                                                          print("sdf");
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            club.clubName,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '@${club.clubName}',
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .bodyText1
                                                          .override(
                                                            fontFamily: 'Poppins',
                                                            color: const Color(
                                                                0xFF787878),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.normal,
                                                          ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                5, 0, 5, 15),
                                        child: Icon(
                                          Icons.verified_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryColor,
                                          size: 16,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: toggleFollow,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          child: Text(
                                            isFollow ? 'Unfollow' : 'Follow',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(0,0,100,0),
                                   child: TabBar(
                                    dividerHeight: 0,
                                               indicatorPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                               unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                                               labelColor: Colors.white,
                                               indicatorSize: TabBarIndicatorSize.tab,
                                               indicator: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(10),
                                                 color: Colors.black,
                                               )
                                               ,tabs: 
                                                                   const [
                                    Tab(
                                      child: Text('Posts',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Tab(
                                      child: Text('Events',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Tab(
                                      child: Text('Bio',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                                                   ]),
                                 ),
                                
                                          
                                // Padding(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       10, 10, 140, 10),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         child: Padding(
                                //           padding: const EdgeInsetsDirectional
                                //               .fromSTEB(0, 8, 0, 8),
                                //           child: Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceEvenly,
                                //             children: [
                                //               TextButton(
                                //                 onPressed: () {},
                                //                 style: TextButton.styleFrom(
                                //                     backgroundColor:
                                //                         Colors.black),
                                //                 child: const Text('Posts',
                                //                     style: TextStyle(
                                //                         color: Colors.white)),
                                //               ),
                                //               TextButton(
                                //                 onPressed: () {},
                                //                 style: TextButton.styleFrom(
                                //                     backgroundColor:
                                //                         Colors.black),
                                //                 child: const Text('Events',
                                //                     style: TextStyle(
                                //                         color: Colors.white)),
                                //               ),
                                //               TextButton(
                                //                 onPressed: () {},
                                //                 style: TextButton.styleFrom(
                                //                     backgroundColor:
                                //                         Colors.black),
                                //                 child: const Text('Bio',
                                //                     style: TextStyle(
                                //                         color: Colors.white)),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),



                                  SizedBox(
                                    height: eventListLength,// or any fraction,
                                    child:  TabBarView(
                                              children: [
                                              // Posts Tab
                                              Container(
                                                padding: const EdgeInsets.all(0),
                                                child: const Center(
                                                    child:
                                                        Text("No Posts Available")),
                                              ),
                                              // Events Tab
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                child: eventList.isNotEmpty
                                                    ? ListView.builder(
                                                        itemCount: eventList.length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          // get an Event from eventList
                                                          Object object =
                                                              eventList[index];
                                              
                                                          return EventTile(
                                                            event: object as Event,
                                                          );
                                                        },
                                                      )
                                                    : const Center(
                                                        child: Text(
                                                            "No Events Available")),
                                              ),
                                              // Bio Tab
                                              Container(
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      club.bio,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        
                                        ],
                                            ),
                                  ),
                              

                                
                                
                                       
                    
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                                  
              ), 
              


            );
          }
        });
  }
}

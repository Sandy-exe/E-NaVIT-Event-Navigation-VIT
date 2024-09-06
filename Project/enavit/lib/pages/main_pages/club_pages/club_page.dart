import 'dart:math';

import 'package:enavit/components/Event_announcement_tile.dart';
import 'package:enavit/components/event_tile.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enavit/components/flutter_flow_theme.dart';
import 'package:enavit/models/og_models.dart';

class ClubBio extends StatefulWidget {
  final Club club;
  ClubBio({super.key, required this.club});

  @override
  State<ClubBio> createState() => _ClubBioState();
}

class _ClubBioState extends State<ClubBio> {
  late List<dynamic> eventList = [];
  late double eventListLength;
  late List<dynamic> postList = [];
  late double postListLength;
  late double tabLength;

  bool isFollow = false; //random

  void toggleFollow() async {
    Services services = Services();
    bool newFollowStatus = await services.toggleFollowClubs(widget.club.clubId);
    setState(() {
      isFollow = newFollowStatus;
    });
  }

  Future<void> initPrefs(String clubId) async {
    Services service = Services();
    eventList = await service.getClubEvents(clubId);
    isFollow = await service.checkFollowClub(clubId);
    print(eventList.length);
    postList = await service.getClubPosts(clubId);
    eventListLength = (600 * eventList.length.toDouble());
    postListLength = (300 * postList.length.toDouble());
    tabLength = max(eventListLength, postListLength);

    isFollow = await service.checkFollowClub(widget.club.clubId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initPrefs(widget.club.clubId),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              
                backgroundColor: Colors.grey[300],
                body:Center(
              child: CircularProgressIndicator(),
            ));
          } else {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Container(
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 150, 0, 0),
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
                                                          widget.club.events
                                                              .length
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                        Text(
                                                          'Events',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                          widget.club.followers
                                                              .length
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                        Text(
                                                          'Followers',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                          widget
                                                              .club.posts.length
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                        Text(
                                                          'Posts',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                    width: 30,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .arrow_drop_down_rounded,
                                                      color: Color(0xFF333333),
                                                      size: 20,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    widget.club.clubName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // SizedBox(
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.6,
                                          //   child: Flexible(
                                          //     child: Text(
                                          //       widget.club.clubName,
                                          //       softWrap: true,
                                          //       maxLines: 2,
                                          //       overflow: TextOverflow.ellipsis,
                                          //       style: FlutterFlowTheme.of(context)
                                          //           .bodyText1,
                                          //     ),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '@${widget.club.clubName}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                // Container(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       0, 0, 0, 0),
                                //   child: ListView.builder(
                                //       itemCount: eventList.length,
                                //       shrinkWrap: true,
                                //       physics:
                                //           const NeverScrollableScrollPhysics(),
                                //       itemBuilder: (context, index) {
                                //         // get a Event from Event list
                                //         Object object = eventList[index];

                                //         return EventTile(
                                //           event: object as Event,
                                //         );
                                //       }),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 100, 0),
                                  child: TabBar(
                                      dividerHeight: 0,
                                      indicatorPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                      unselectedLabelColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      labelColor: Colors.white,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                      tabs: const [
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
                                SizedBox(
                                  height: tabLength < 10
                                      ? 1000
                                      : tabLength, // or any fraction,
                                  child: TabBarView(
                                    children: [
                                      // Posts Tab
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: postList.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: postList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final announcement =
                                                      postList[index];
                                                  return AnnouncementTile(
                                                    announcement: announcement,
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child:
                                                    Text("No Posts Available")),
                                      ),
                                      // Events Tab
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: eventList.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: eventList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
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

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 20, 10, 40),
                                        child: Container(
                                          height: 100,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 209, 208, 208),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "About Us",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          24, // Increased font size
                                                    ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                widget.club.bio,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize:
                                                          18, // Increased font size
                                                      height: 1.5,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
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

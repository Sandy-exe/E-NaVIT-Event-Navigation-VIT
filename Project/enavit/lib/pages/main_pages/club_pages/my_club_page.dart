import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enavit/components/flutter_flow_theme.dart';
import 'package:enavit/models/og_models.dart';

class ClubBio extends StatefulWidget {
  final Club club;
  const ClubBio({super.key, required this.club});
   
  @override
  
  State<ClubBio> createState() => _ClubBioState();
}

class _ClubBioState extends State<ClubBio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/Survey_Corps.jpg'),
            alignment: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding:  const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 150, 0, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        'lib/images/Mikasa_eren.jpg',
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsetsDirectional.fromSTEB(35, 40, 0, 0),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 70,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '604',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                                ),
                                                Text(
                                                  'Posts',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            const Color(0xFFB3B3B3),
                                                        fontSize: 8,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 70,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '705k',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                                ),
                                                Text(
                                                  'Followers',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            const Color(0xFFB3B3B3),
                                                        fontSize: 8,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 70,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '12',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                                ),
                                                Text(
                                                  'Following',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            const Color(0xFFB3B3B3),
                                                        fontSize: 8,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_drop_down_rounded,
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                widget.club.clubName,
                                style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                child: Icon(
                                  Icons.verified_rounded,
                                  color: FlutterFlowTheme.of(context).primaryColor,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                '@erenyeager',
                                style:
                                    FlutterFlowTheme.of(context).bodyText1.override(
                                          fontFamily: 'Poppins',
                                          color: const Color(0xFF787878),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                              ),
                            ],
                          ),
                        ),
                        // Generated code for this Row Widget...
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 100, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                        },
                                        style: TextButton.styleFrom(backgroundColor: Colors.black),
                                        child: const Text('Posts', style: TextStyle(color: Colors.white)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                        },
                                        style: TextButton.styleFrom(backgroundColor: Colors.black),
                                        child: const Text('Status', style: TextStyle(color: Colors.white)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                        },
                                        style: TextButton.styleFrom(backgroundColor: Colors.black),
                                        child: const Text('Bio', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 15),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'lib/images/Mikasa_eren.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(5, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Eren Yeager',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 12,
                                                                      ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      2, 0, 0, 0),
                                                              child: Icon(
                                                                Icons
                                                                    .verified_rounded,
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .primaryColor,
                                                                size: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              '@erenyeager',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: const Color(
                                                                            0xFF787878),
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                      ),
                                                            ),
                                                            Text(
                                                              ' • ',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: const Color(
                                                                            0xFF787878),
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                      ),
                                                            ),
                                                            Text(
                                                              '2 hours ago',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: const Color(
                                                                            0xFF787878),
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                      ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const FaIcon(
                                                FontAwesomeIcons.ellipsisVertical,
                                                color: Color(0xFF787878),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 5),
                                                  child: Text(
                                                    'I\'ve always been fixated on freedom. The dream of breaking free from the walls consumed me. Armin\'s book showed me a world beyond, a world I yearned for. Titans, the very creatures that stole my freedom, became my target. I believed every person is born free, and I\'d eliminate anyone who tried to take that away.',
                                                    style:
                                                        FlutterFlowTheme.of(context)
                                                            .bodyText1
                                                            .override(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight.normal,
                                                            ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  'lib/images/Freedom_eren.jpg',
                                                  width: 500,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Image.network(
                                                              'https://picsum.photos/seed/711/600',
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.10, 0.00),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.white,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                              ),
                                                              child: Image.network(
                                                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0, 0, 10, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 5, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize.max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .message,
                                                                color:
                                                                    Color(0xFF787878),
                                                                size: 12,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        3, 0, 2, 0),
                                                                child: Text(
                                                                  '21',
                                                                  style: FlutterFlowTheme
                                                                          .of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.favorite,
                                                          color: FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                          size: 16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  3, 0, 2, 0),
                                                          child: Text(
                                                            '212',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons.bookmark_border_outlined,
                                                color: Color(0xFF333333),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'lib/images/Mikasa_eren.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(5, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Eren Yeager',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 12,
                                                                      ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      2, 0, 0, 0),
                                                              child: Icon(
                                                                Icons
                                                                    .verified_rounded,
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .primaryColor,
                                                                size: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '@erenyeager',
                                                          style: FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily: 'Poppins',
                                                                color: const Color(
                                                                    0xFF787878),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight.normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const FaIcon(
                                                FontAwesomeIcons.ellipsisVertical,
                                                color: Color(0xFF787878),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(),
                                            child: Text(
                                              'When Titans were the greatest threat, Titans were the enemy. When countries were the greatest threat, countries were the enemy. For as long as people hold firm to different beliefs, there will always be an enemy.',
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Image.network(
                                                              'https://picsum.photos/seed/711/600',
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.10, 0.00),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.white,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                              ),
                                                              child: Image.network(
                                                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0, 0, 10, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 5, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize.max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .message,
                                                                color:
                                                                    Color(0xFF787878),
                                                                size: 12,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        3, 0, 2, 0),
                                                                child: Text(
                                                                  '4',
                                                                  style: FlutterFlowTheme
                                                                          .of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.favorite,
                                                          color: FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                          size: 16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  3, 0, 2, 0),
                                                          child: Text(
                                                            '12',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons.bookmark_border_outlined,
                                                color: Color(0xFF333333),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'lib/images/Mikasa_eren.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(5, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Eren Yeager',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 12,
                                                                      ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      2, 0, 0, 0),
                                                              child: Icon(
                                                                Icons
                                                                    .verified_rounded,
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .primaryColor,
                                                                size: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '@erenyeager',
                                                          style: FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily: 'Poppins',
                                                                color: const Color(
                                                                    0xFF787878),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight.normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const FaIcon(
                                                FontAwesomeIcons.ellipsisVertical,
                                                color: Color(0xFF787878),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(),
                                            child: Text(
                                              'When Titans were the greatest threat, Titans were the enemy. When countries were the greatest threat, countries were the enemy. For as long as people hold firm to different beliefs, there will always be an enemy.',
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Image.network(
                                                              'https://picsum.photos/seed/711/600',
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.10, 0.00),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.white,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                              ),
                                                              child: Image.network(
                                                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0, 0, 10, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 5, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize.max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .message,
                                                                color:
                                                                    Color(0xFF787878),
                                                                size: 12,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        3, 0, 2, 0),
                                                                child: Text(
                                                                  '4',
                                                                  style: FlutterFlowTheme
                                                                          .of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.favorite,
                                                          color: FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                          size: 16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  3, 0, 2, 0),
                                                          child: Text(
                                                            '12',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons.bookmark_border_outlined,
                                                color: Color(0xFF333333),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'lib/images/Mikasa_eren.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(5, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Eren Yeager',
                                                              style:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 12,
                                                                      ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      2, 0, 0, 0),
                                                              child: Icon(
                                                                Icons
                                                                    .verified_rounded,
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .primaryColor,
                                                                size: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '@erenyeager',
                                                          style: FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily: 'Poppins',
                                                                color: const Color(
                                                                    0xFF787878),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight.normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const FaIcon(
                                                FontAwesomeIcons.ellipsisVertical,
                                                color: Color(0xFF787878),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(),
                                            child: Text(
                                              'When Titans were the greatest threat, Titans were the enemy. When countries were the greatest threat, countries were the enemy. For as long as people hold firm to different beliefs, there will always be an enemy.',
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Image.network(
                                                              'https://picsum.photos/seed/711/600',
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.10, 0.00),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.white,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                              ),
                                                              child: Image.network(
                                                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0, 0, 10, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 5, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize.max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .message,
                                                                color:
                                                                    Color(0xFF787878),
                                                                size: 12,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        3, 0, 2, 0),
                                                                child: Text(
                                                                  '4',
                                                                  style: FlutterFlowTheme
                                                                          .of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize: 10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.favorite,
                                                          color: FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                          size: 16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  3, 0, 2, 0),
                                                          child: Text(
                                                            '12',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons.bookmark_border_outlined,
                                                color: Color(0xFF333333),
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
}

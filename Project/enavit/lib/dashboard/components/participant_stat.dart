import 'package:enavit/dashboard/models/stats_models.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/stats_services.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'chart.dart';
import 'participant_stat_card.dart';

class ParticipantStat extends StatefulWidget {
  final Event event;
  const ParticipantStat({super.key
  , required this.event});

  @override
  ParticipantStatState createState() => ParticipantStatState();
}

class ParticipantStatState extends State<ParticipantStat> {

  late Map<String, dynamic> statData;
  late List<ParticipantDetailsCard> participantList;
  late int totalParticipants;
  
  @override
  void initState() {
    super.initState();
    statDataRetreive(widget.event);
  }

  
  Future<void> statDataRetreive(Event event) async {
  
    statData = await Stats().statData(event);

    totalParticipants = statData['totalParticipants'];


    participantList = [
      ParticipantDetailsCard(
        pngSrc: "lib/images/SVG/CSEcore.png",
        title: "CSE Core", 
        totalparticipants: statData['BCE'].toString(),
        color: primaryColor
        ),
      ParticipantDetailsCard(
        pngSrc: "lib/images/SVG/robotics.png",
        title: "Robotics", 
        totalparticipants: statData['BRS'].toString(),
        color: primaryColor
        ),
      ParticipantDetailsCard(
        pngSrc: "lib/images/SVG/ai.png",
        title: "AIML", 
        totalparticipants: statData['AIML'].toString(),
        color: primaryColor
        ),
      ParticipantDetailsCard(
        pngSrc: "lib/images/SVG/other.png",
        title: "Others", 
        totalparticipants: statData['Others'].toString(),
        color: primaryColor
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: statDataRetreive(widget.event),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Participant Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Chart(participantData: participantList,totalParticipants: totalParticipants,),
          const SizedBox(height: defaultPadding),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: participantList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                  left: 5,
                  right: 5), // Add space at the bottom
              child: ParticipantStatCard(card: participantList[index]),
            ),
          )
        ],
      ),
    );
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}

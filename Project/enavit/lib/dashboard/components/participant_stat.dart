import 'package:flutter/material.dart';

import '../constants.dart';
import 'chart.dart';
import 'participant_stat_card.dart';

class ParticipantStat extends StatelessWidget {
  const ParticipantStat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Participant Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          // ParticipantStatCard(
          //   pngSrc: "lib/images/SVG/CSEcore.png",
          //   title: "CSE Core",
          //   amountOfFiles: "1.3GB",
          //   numOfFiles: 1328,
          // ),
          // ParticipantStatCard(
          //   pngSrc: "lib/images/SVG/robotics.png",
          //   title: "Robotics",
          //   amountOfFiles: "15.3GB",
          //   numOfFiles: 1328,
          // ),
          // ParticipantStatCard(
          //   pngSrc: "lib/images/SVG/ai.png",
          //   title: "AI and ML",
          //   amountOfFiles: "1.3GB",
          //   numOfFiles: 1328,
          // ),
          // ParticipantStatCard(
          //   pngSrc: "lib/images/SVG/other.png",
          //   title: "Others",
          //   amountOfFiles: "1.3GB",
          //   numOfFiles: 140,
          // ),
        ],
      ),
    );
  }
}

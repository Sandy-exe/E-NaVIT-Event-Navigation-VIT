import 'package:enavit_main/dashboard/models/stats_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Chart extends StatefulWidget {
  final List<ParticipantDetailsCard> participantData;
  final int totalParticipants;

  const Chart(
      {super.key,
      required this.participantData,
      required this.totalParticipants});

  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {
  late List<PieChartSectionData> paiChartSelectionData;

  @override
  void initState() {
    super.initState();

    paiChartSelectionData = [
      PieChartSectionData(
        color: primaryColor,
        value: double.parse(widget.participantData[0].totalparticipants) *
            100 /
            widget.totalParticipants,
        showTitle: false,
        radius: 25,
      ),
      PieChartSectionData(
        color: const Color(0xFF26E5FF),
        value: double.parse(widget.participantData[1].totalparticipants) *
            100 /
            widget.totalParticipants,
        showTitle: false,
        radius: 22,
      ),
      PieChartSectionData(
        color: const Color(0xFFFFCF26),
        value: double.parse(widget.participantData[2].totalparticipants) *
            100 /
            widget.totalParticipants,
        showTitle: false,
        radius: 19,
      ),
      PieChartSectionData(
        color: const Color(0xFFEE2727),
        value: double.parse(widget.participantData[3].totalparticipants) *
            100 /
            widget.totalParticipants,
        showTitle: false,
        radius: 16,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  widget.totalParticipants.toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const SizedBox(height: defaultPadding / 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

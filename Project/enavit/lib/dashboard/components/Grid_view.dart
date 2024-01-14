import 'package:enavit/dashboard/models/D_models.dart';
import 'package:enavit/models/og_models.dart';
import 'package:flutter/material.dart';
import 'card_info.dart';


class StatInfoCardListView extends StatelessWidget {
  final Event event;
  const StatInfoCardListView({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items in a row // Space between items vertically
          ),
          itemCount: displayRow1.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 12.0, right: 5.0, left: 5.0),
            child: StatInfoCard(info: displayRow1[index]),
          ),
        ),
        ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: displayRow2.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 5.0,bottom: 5.0,left: 5,right: 5), // Add space at the bottom
          child: StatInfoCard(info: displayRow2[index]),
        ),
      )
      ],
    );
  }
}

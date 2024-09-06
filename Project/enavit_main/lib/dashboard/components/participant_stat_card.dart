import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/stats_models.dart';

class ParticipantStatCard extends StatelessWidget {
  const ParticipantStatCard({super.key, required this.card});
  final ParticipantDetailsCard card;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(card.pngSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
                  ),
                  
                ],
              ),
            ),
          ),
          Text(card.totalparticipants,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: const Color.fromARGB(179, 0, 0, 0))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants.dart';

class ParticipantStatCard extends StatelessWidget {
  const ParticipantStatCard({
    super.key,
    required this.title,
    required this.pngSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
  });

  final String title, pngSrc, amountOfFiles;
  final int numOfFiles;

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
            child: Image.asset(pngSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
                  ),
                  Text(
                    "$numOfFiles",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          ),
          Text(amountOfFiles,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: const Color.fromARGB(179, 0, 0, 0))),
        ],
      ),
    );
  }
}

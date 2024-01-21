import 'package:enavit/dashboard/models/stats_models.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class StatInfoCard extends StatelessWidget {
  const StatInfoCard({
    super.key,
    required this.info,
  });

  final SquareCardInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset(
                  info.pngSrc!,
                  color: info.color ?? Colors.black,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            info.title!,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: defaultPadding / 2),
          ProgressLine(
            color: info.color,
            percentage: info.percentage,
          ),
          const SizedBox(height: defaultPadding / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.stat}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
              ),
              Text(
                info.totalstat!.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color = primaryColor,
    required this.percentage,
  });

  final Color? color;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}


class FinanceCard extends StatelessWidget {
  const FinanceCard({
    super.key,
    required this.info,
  });

  final FinanceCardInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset(
                  info.pngSrc!,
                  color: info.color ?? Colors.black,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            "Expense",
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: defaultPadding / 2),
          ProgressLine(
            color: info.color,
            percentage: info.expercentage,
          ),
          const SizedBox(height: defaultPadding / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.expense}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
              ),
              Text(
                info.budget!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            "Revenue",
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: defaultPadding / 2),
          ProgressLine(
            color: info.color,
            percentage: info.repercentage,
          ),
          const SizedBox(height: defaultPadding / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.revenue}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
              ),
              Text(
                info.expectedRevenue!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
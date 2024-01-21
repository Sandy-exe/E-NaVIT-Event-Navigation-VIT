import 'dart:ffi';

import 'package:enavit/dashboard/constants.dart';
import 'package:flutter/material.dart';

class SquareCardInfo {
  final String? pngSrc, title, totalstat,stat;
  final double?  percentage;
  final Color? color;

  SquareCardInfo({
    this.pngSrc,
    this.title,
    this.totalstat,
    this.stat,
    this.percentage,
    this.color,
  });
}

class FinanceCardInfo {
  final String? pngSrc, title, budget, expectedRevenue;
  final double? expense, percentage, revenue;
  final Color? color;

  FinanceCardInfo({
    this.pngSrc,
    this.title,
    this.budget,
    this.expectedRevenue,
    this.expense,
    this.revenue,
    this.percentage,
    this.color,
  });
}

class ParticipantDetailsCard {
  final String pngSrc, title, totalparticipants;
  final int numOfParticipants;
  final Color color;

  ParticipantDetailsCard({
    required this.pngSrc,
    required this.title,
    required this.totalparticipants,
    required this.numOfParticipants,
    required this.color,
  });
}



List displayRow2 = [
  FinanceCardInfo(
    title: "Finance",
    expense: 1000.0,
    revenue: 2000.0,
    budget: "10000",
    expectedRevenue: "20000",

    pngSrc: "lib/images/SVG/money-bag.png",
    color: const Color(0xFFFFA113),
    percentage: 0.0,
  ),
];

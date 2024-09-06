
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
  final double? expense, expercentage,repercentage, revenue;
  final Color? color;

  FinanceCardInfo({
    this.pngSrc,
    this.title,
    this.budget,
    this.expectedRevenue,
    this.expense,
    this.revenue,
    this.repercentage,
    this.expercentage,
    this.color,
  });
}

class ParticipantDetailsCard {
  final String pngSrc, title, totalparticipants;
  final Color color;

  ParticipantDetailsCard({
    required this.pngSrc,
    required this.title,
    required this.totalparticipants,
    required this.color,
  });
}




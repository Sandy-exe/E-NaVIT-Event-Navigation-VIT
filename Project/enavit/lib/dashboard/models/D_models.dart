import 'package:enavit/dashboard/constants.dart';
import 'package:flutter/material.dart';

class CardInfo {
  final String? pngSrc, title, totalstat;
  final int? stat, percentage;
  final Color? color;

  CardInfo({
    this.pngSrc,
    this.title,
    this.totalstat,
    this.stat,
    this.percentage,
    this.color,
  });
}


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

List displayRow1 = [
  CardInfo(
    title: "Attendance",
    stat: 40,
    pngSrc: "assets/icons/Documents.svg",
    totalstat: "100",
    color: primaryColor,
    percentage: 40,
  ),
  CardInfo(
    title: "Issues",
    stat: 10,
    pngSrc: "assets/icons/one_drive.svg",
    totalstat: "1GB",
    color: const Color(0xFFA4CDFF),
    percentage: 0,
  ),
];

List displayRow2 = [
  CardInfo(
    title: "Finance",
    stat: 100,
    pngSrc: "assets/icons/google_drive.svg",
    totalstat: "0",
    color: const Color(0xFFFFA113),
    percentage: 0,
  ),
];

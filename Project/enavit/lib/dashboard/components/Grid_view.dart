import 'package:enavit/dashboard/components/card_info.dart';
import 'package:enavit/dashboard/constants.dart';
import 'package:enavit/dashboard/models/stats_models.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/stats_services.dart';
import 'package:flutter/material.dart';

class StatInfoCardListView extends StatefulWidget {
  final Event event;
   
  const StatInfoCardListView({
    super.key,
    required this.event,
  });

  @override
  StatInfoCardListViewState createState() => StatInfoCardListViewState();
}
class StatInfoCardListViewState extends State<StatInfoCardListView> {

  late Map<String, dynamic> statData;
  late List attendanceIssue= [];
  late List financeCard=[];
  
  @override
  void initState() {
    super.initState();
    statDataRetreive(widget.event);
  }

  
  Future<void> statDataRetreive(Event event) async {
    
    statData = await Stats().statData(event);
    

    attendanceIssue = [
      SquareCardInfo(
        title: "Attendance",
        stat: statData['attendancePresent'].toString(),
        pngSrc: "lib/images/SVG/attendance.png",
        totalstat: statData['totalParticipants'].toString(),
        color: primaryColor,
        percentage: ((double.parse(statData['attendancePresent'].toString()) /
                (statData['totalParticipants'] as int).toDouble() )*
                100),
      ),
      SquareCardInfo(
        title: "Issues",
        stat: statData['issuesSolved'].toString(),
        pngSrc: "lib/images/SVG/issues.png",
        totalstat: statData['totalIssues'].toString(),
        color: primaryColor,
        percentage: ((statData['issuesSolved'] as int).toDouble() == 0.0 ? 1 : 0 /(statData['totalIssues'] as int ).toDouble())*100,
      ),
    ];

    print("ok");
    print(((double.parse(statData['totalexpense'])/ double.parse(statData['totalbudget'])) *
        100));
    financeCard = [
      FinanceCardInfo(
        title: "Total Revenue",
        color: primaryColor,
        pngSrc: "lib/images/SVG/money-bag.png",
        budget: statData['totalbudget'].toString(),
        expectedRevenue: statData['expectedrevenue'].toString(),
        expense: double.parse(statData['totalexpense']),
        revenue: statData['totalrevenue'],
        repercentage: ((statData['totalrevenue'] == 0.0 ? 1: statData['totalrevenue'] /
            double.parse(statData['expectedrevenue']==0.0 ? 1 : statData['expectedrevenue'] )) *
          100),
        expercentage: ((double.parse(statData['totalexpense'])/double.parse(statData['totalbudget'])) *
          100),
      ),
    ];

    
    
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: statDataRetreive(widget.event),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      2, // Number of items in a row // Space between items vertically
                ),
                itemCount: attendanceIssue.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 12.0, right: 5.0, left: 5.0),
                  child: StatInfoCard(info: attendanceIssue[index]),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: financeCard.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                      left: 5,
                      right: 5), // Add space at the bottom
                  child: FinanceCard(info: financeCard[index]),
                ),
              )
            ],
          );
        } else {
          return const CircularProgressIndicator();
          
          }
      },
    );
  }
}







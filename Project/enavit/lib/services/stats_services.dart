import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/components/approver_search_model.dart';
import 'package:enavit/components/approver_event_search_model.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/home_search_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Stats {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SecureStorage secureStorage = SecureStorage();

  Future <Map<String,dynamic>> statData(Event event) async {
    Map<String, dynamic> currentUserData = jsonDecode( await secureStorage.reader(key: "currentUserData") ?? "null");
    print(currentUserData['role']);
    //List<Event> eventListObj = jsonDecode(await secureStorage.reader(key: "events")?? "null"); 

    if (currentUserData['role'] == 0) {
        Map<String, dynamic> statdata = {};
        statdata['totalParticipants'] = event.participants.length;
        statdata['attendancePresent'] = event.attendancePresent;
        statdata['totalIssues'] = event.issues.length;

        int issuesSolved = 0;
        event.issues.forEach((key, value) {
          if (value['Status'] == '0') {
            issuesSolved++;
          }
        });

        statdata['issuesSolved'] = issuesSolved;

        statdata['totalexpense'] = event.expense;
        statdata['totalbudget'] = event.budget;
        statdata['totalrevenue'] = event.revenue;
        statdata['expectedrevenue'] = event.expectedRevenue;

        return statdata; 
    }


    return {};
  }


}
import 'dart:convert';
import 'dart:ffi';

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

  Future<Map<String, dynamic>> statData(Event event) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
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

      //BRS,BCE,AIML,Others
      statdata['BRS'] = 0;
      statdata['BCE'] = 0;
      statdata['AIML'] = 0;
      statdata['Others'] = 0;


      final allusers = await firestore.collection("app_users").get();

      List<String> allparticipants = event.participants;
      
      print(allparticipants);
      for (var element in allusers.docs) {
        print(element.data()['userid']);
          
            
            if (allparticipants.contains(element.data()['userid'] ) && element.data()['reg_no']!=null ) {
              print(
              element.data()['reg_no'].substring(2, 5).toUpperCase());
              if (element.data()['reg_no'].substring(2,5).toUpperCase() == "BRS" ) {
                statdata['BRS']++;
              } else if (element.data()['reg_no'].substring(2,5).toUpperCase() == "BCE") {
                statdata['BCE']++;
              } else if (element.data()['reg_no'].substring(2,5).toUpperCase() == "AIML") {
                statdata['AIML']++;
              } else {
                statdata['Others']++;
              }
            }
          }
        return statdata;
        }

      
      return {};
      }
    }


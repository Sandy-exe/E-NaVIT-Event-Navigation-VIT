import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/Data/secure_storage.dart';

class Stats {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SecureStorage secureStorage = SecureStorage();

  Future<Map<String, dynamic>> statData(Event event) async {
    Map<String, dynamic> currentUserData = jsonDecode(
        await secureStorage.reader(key: "currentUserData") ?? "null");
    //List<Event> eventListObj = jsonDecode(await secureStorage.reader(key: "events")?? "null");

    if (currentUserData['role'] == 0 || currentUserData['role'] == 1) {
      Map<String, dynamic> statdata = {};
      statdata['totalParticipants'] = event.participants.length;
      statdata['attendancePresent'] = event.attendancePresent.length;
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

      print(event.expense);
      print(event.revenue);

      statdata['totalrevenue'] = double.parse(event.fee)* event.participants.length;
      print(statdata);
      statdata['expectedrevenue'] = event.revenue;

      //BRS,BCE,AIML,Others
      statdata['BRS'] = 0;
      statdata['BCE'] = 0;
      statdata['AIML'] = 0;
      statdata['Others'] = 0;


      final allusers = await firestore.collection("app_users").get();

      List<String> allparticipants = event.participants;
    
      for (var element in allusers.docs) {
            if (allparticipants.contains(element.data()['userid'] ) && element.data()['reg_no']!=null ) {
             
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
        print(statdata);
        return statdata;
        }

      return {};
      }
    }


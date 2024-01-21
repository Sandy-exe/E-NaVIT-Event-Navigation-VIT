import 'dart:convert';

import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/approval_tile.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/authentication_service.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CompleteEventDetailPage extends StatefulWidget {
  const CompleteEventDetailPage({super.key});

  @override
  State<CompleteEventDetailPage> createState() =>
      _CompleteEventDetailPageState();
}

class _CompleteEventDetailPageState extends State<CompleteEventDetailPage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();
  SecureStorage secureStorage = SecureStorage();
  late String role;

  late bool isLoggedIn;
  late Map<String, dynamic> currentUserData;
  late List<Approval> approvalList;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    Services services = Services();
    SecureStorage secureStorage = SecureStorage();

    isLoggedIn = await secureStorage.reader(key: 'isLoggedIn') == 'true';
    role = await secureStorage.reader(key: 'roleState') ?? 'true';

    if (isLoggedIn) {
      String? currentUserDataString =
          await secureStorage.reader(key: "currentUserData");
      if (currentUserDataString != null) {
        currentUserData = jsonDecode(currentUserDataString);
      }
    }

    approvalList = await services.getApprovalList(
        currentUserData['userId'] ?? "1WUUvpRk77bPn6agLydmqvBMoiR2");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: approvalList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // get a Event from Event list
                    //Object object = value.eventClubListHome[index];
                    Approval approval = approvalList[index];
                    return ApprovalTile(
                      approval: approval,
                    );
                    // if (object is Club) {
                    //   return ClubTile(
                    //     club: object,
                    //   );
                    // } else {
                    //   return EventTile(
                    //     event: object as Event,
                    //   );
                    // }
                  },
                ),
              ),
            ],
          );
          // Scaffold(
          //   body: SingleChildScrollView(
          //     child: Text(
          //         currentUserData['approval_events'][0] ?? "not working boss"),
          //   ),
          // );
        }
      },
    );
  }
}

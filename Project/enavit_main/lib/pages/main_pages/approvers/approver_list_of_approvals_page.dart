import 'dart:convert';

import 'package:enavit_main/Data/secure_storage.dart';
import 'package:enavit_main/components/approval_tile.dart';
import 'package:enavit_main/models/og_models.dart';
import 'package:enavit_main/services/authentication_service.dart';
import 'package:enavit_main/services/services.dart';
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

    approvalList =
        await services.getApprovalList(currentUserData['userid'] ?? "");
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
          return Scaffold(
            appBar: AppBar(
              title: Text('List of approvals'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: approvalList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Approval approval = approvalList[index];
                      return ApprovalTile(
                        approval: approval,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

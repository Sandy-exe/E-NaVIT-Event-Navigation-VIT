import 'dart:convert';

import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/Pending_tile.dart';
import 'package:enavit/components/approval_tile.dart';
import 'package:enavit/components/approved_tile.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';

class OrganiserApprovalPendingRequest extends StatefulWidget {
  const OrganiserApprovalPendingRequest({super.key});

  @override
  State<OrganiserApprovalPendingRequest> createState() =>
      _OrganiserApprovalPendingRequestState();
}

class _OrganiserApprovalPendingRequestState
    extends State<OrganiserApprovalPendingRequest> {
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

    approvalList = await services.getApprovalList(currentUserData['userid']);

    print(approvalList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.grey[300],
              body: Center(
                child: CircularProgressIndicator(),
              ));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('List of approved approvals'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: approvalList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Approval approval = approvalList[index];
                      return PendingTile(
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

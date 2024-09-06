import 'package:boxy/flex.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_approval_creation_page.dart';
import 'package:enavit_main/pages/main_pages/Captain/organiser_approval_pending_request.dart';
import 'package:enavit_main/pages/main_pages/publish_pages/list_of_approved_page.dart';
import 'package:flutter/material.dart';

class OrganiserEventCreationOptionsPage extends StatelessWidget {
  const OrganiserEventCreationOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: BoxyColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/approval.png', // Dummy image URL
                "Request Approval",
                "Start a new approval process",
                () {
                  debugPrint("Create Approvals");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventCreationPage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/pending.png', // Dummy image URL
                "Pending Request",
                "View pending approval requests",
                () {
                  debugPrint("Pending Request");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const OrganiserApprovalPendingRequest(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/upload.png', // Dummy image URL
                "Publish Events",
                "Publish events that have been approved",
                () {
                  debugPrint("Publish Organiser");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListOfApproved(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(BuildContext context, String imageUrl, String title,
      String subtitle, VoidCallback onPressed) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: -20),
          leading: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          onTap: onPressed,
        ),
      ),
    );
  }
}

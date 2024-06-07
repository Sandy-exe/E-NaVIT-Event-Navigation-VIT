import 'package:boxy/flex.dart';
import 'package:enavit/pages/main_pages/Captain/organiser_approval_creation_page.dart';
import 'package:enavit/pages/main_pages/Captain/organiser_approval_pending_request.dart';
import 'package:enavit/pages/main_pages/publish_pages/list_of_approved_page.dart';
import 'package:flutter/material.dart';

class OrganiserEventCreationOptionsPage extends StatelessWidget {
  const OrganiserEventCreationOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BoxyColumn(
        children: [
          Expanded(
            child: BoxyRow(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,              
              children: [
                _buildButton(
                  context,
                  "Create\nApproval",
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
                _buildButton(
                  context,
                  "Pending\nRequest",
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
              ],
            ),
          ),
          Expanded(
            child: _buildButton(
              context,
              "Publish Approved Events",
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
    );
  }

Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      margin:  const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  
}

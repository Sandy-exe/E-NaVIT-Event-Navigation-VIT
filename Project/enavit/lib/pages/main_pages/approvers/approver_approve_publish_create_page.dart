import 'package:boxy/flex.dart';
import 'package:enavit/pages/main_pages/approvers/approver_create_event_page.dart';
import 'package:enavit/pages/main_pages/approvers/approver_list_of_approvals_page.dart';
import 'package:enavit/pages/main_pages/publish_pages/list_of_approved_page.dart';
import 'package:flutter/material.dart';

class ChoiceApprovePublishCreatePage extends StatelessWidget {
  const ChoiceApprovePublishCreatePage({super.key});

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
                  "Approvals",
                  () {
                    debugPrint("Approvals");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompleteEventDetailPage(),
                      ),
                    );
                  },
                ),
                _buildButton(
                  context,
                  "Publish\nEvents",
                  () {
                    debugPrint("Publish");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListOfApproved(),
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
              "Create Events",
              () {
                debugPrint("Create");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateEventPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(10),
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
            textAlign: TextAlign.center,
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
import 'package:boxy/flex.dart';
import 'package:enavit_main/pages/main_pages/approvers/approver_create_event_page.dart';
import 'package:enavit_main/pages/main_pages/approvers/approver_list_of_approvals_page.dart';
import 'package:enavit_main/pages/main_pages/deans/dean_create_club_page.dart';
import 'package:enavit_main/pages/main_pages/deans/dean_edit_club_page.dart';
import 'package:enavit_main/pages/main_pages/publish_pages/list_of_approved_page.dart';
import 'package:flutter/material.dart';

class EditCreateClubPage extends StatelessWidget {
  const EditCreateClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/create_club.png',
                "Create",
                "Create Club",
                () {
                  debugPrint("Create");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateClubPage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/edit_club.png',
                "Edit",
                "Edit Clubs",
                () {
                  debugPrint("Edit");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeanEditClubPage(),
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
            offset: Offset(0, 3),
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

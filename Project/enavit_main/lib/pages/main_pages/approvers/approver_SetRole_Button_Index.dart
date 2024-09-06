import 'package:boxy/flex.dart';
import 'package:flutter/material.dart';

class SetRoleButtonIndexPage extends StatefulWidget {
  const SetRoleButtonIndexPage({super.key});

  @override
  _SetRoleButtonIndexPageState createState() => _SetRoleButtonIndexPageState();
}

class _SetRoleButtonIndexPageState extends State<SetRoleButtonIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Operation"),
      ),
      body: Center(
        child: BoxyColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/Captain.png', // Example image URL
                "Set Captain Roles",
                "Assign roles to participants",
                () {
                  Navigator.pushNamed(context, '/captain_setRole');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildCardButton(
                context,
                'lib/images/Organiser.png', // Example image URL
                "Set Organiser Roles",
                "Assign Organiser Roles to participants",
                () {
                  Navigator.pushNamed(context, '/organiser_setRole');
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
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
      body: BoxyColumn(
        mainAxisAlignment: MainAxisAlignment.center, // Add this line
        children: [
          Expanded(
            child: _buildButton(
              context,
              "Set Captain Roles",
              () {
                
                Navigator.pushNamed(context, '/captain_setRole');
              },
            ),
          ),
          Expanded(
            child: _buildButton(
              context,
              "Set Organiser Roles",
              () {
                Navigator.pushNamed(context, '/organiser_setRole');
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



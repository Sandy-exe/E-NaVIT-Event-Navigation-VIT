import 'package:flutter/material.dart';

class AProfilePage extends StatefulWidget {
  const AProfilePage({super.key});

  @override
  State<AProfilePage> createState() => _AProfilePageState();
}

class _AProfilePageState extends State<AProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Approver Profile Page"),
    );
  }
}
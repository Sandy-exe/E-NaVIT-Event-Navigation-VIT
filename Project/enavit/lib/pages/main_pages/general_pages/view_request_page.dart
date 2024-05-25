import 'package:flutter/material.dart';


class ViewRequestPage extends StatefulWidget {
  const ViewRequestPage({super.key});

  @override
  _ViewRequestPageState createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Request"),
      ),
      body: Container(
        child: const Center(
          child: Text("View Request Page"),
        ),
      ),
    );
  }
}
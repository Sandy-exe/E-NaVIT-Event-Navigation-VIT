import 'package:flutter/material.dart';

class SetRole extends StatefulWidget {
  const SetRole({super.key});

  @override
  State<SetRole> createState() => _SetRoleState();
}

class _SetRoleState extends State<SetRole> {
  late List eventList = [];
  late int eventListLength;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrefs() async {
    Services service = Services();
    eventList = await service.getEventClubData(context);
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
            return Stack(
              fit: StackFit.expand,
              children: [
                buildsetrolepage(),
                const FloatingSearchBarWidgetApprover(),
              ],
            );
          }
        });
  }
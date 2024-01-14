import 'components/Grid_view.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

import 'components/participant_stat.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        StatInfoCardListView(),
                        // FileInfoCardGridView(
                        //     crossAxisCount: _size.width < 650 ? 2 : 4,
                        //     childAspectRatio:
                        //        _size.width < 650 && _size.width > 350 ? 1.3 : 1,
                        //   ),
                        SizedBox(height: defaultPadding),
                        //const RecentFiles(),
                        ParticipantStat(),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

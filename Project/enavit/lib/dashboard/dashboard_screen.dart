import 'package:enavit/services/services.dart';

import 'components/Grid_view.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import '../models/og_models.dart';

import 'components/participant_stat.dart';

class DashboardScreen extends StatelessWidget {
  final Event event;
  const DashboardScreen({super.key, required this.event});

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
        actions: [
          // PopupMenuButton<String>(
          //   onSelected: (String result) {
          //     // Handle menu option selection
          //     if (result == 'Update Expense') {
          //       // Perform action for Option 1
          //     } else if (result == 'Update Expected Revenue') {
          //       // Perform action for Option 2
          //     }
          //     // Add more options as needed
          //   },
          //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //     const PopupMenuItem<String>(
          //       value: 'Update Expense',
          //       child: Text('Update Expense'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'Update Expected Revenue',
          //       child: Text('Update Expected Revenue'),
          //     ),
          //     // Add more PopupMenuItem widgets here if needed
          //   ],
          //   icon: const Icon(Icons.more_vert),
          // ),
          PopupMenuButton<String>(
            onSelected: (String result) async {
              String? userInput = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController inputController =
                      TextEditingController();

                  return AlertDialog(
                    title: Text(result),
                    content: TextField(
                      controller: inputController,
                      decoration:
                          const InputDecoration(hintText: "Enter value"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(inputController.text);
                        },
                        child: const Text('Submit'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Close the dialog without returning any value
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );

              if (userInput != null && userInput.isNotEmpty) {
                Services service = Services();
                if (result == 'Update Expense') {
                  String response = service.updateExpense(userInput, event) as String;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response),
                    ),
                  );
                } else if (result == 'Update Expected Revenue') {
                  String response = service.updateExpectedRevenue(userInput, event) as String;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response),
                    ),
                  );

                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Update Expense',
                child: Text('Update Expense'),
              ),
              const PopupMenuItem<String>(
                value: 'Update Expected Revenue',
                child: Text('Update Expected Revenue'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),

        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        StatInfoCardListView(event: event),
                        const SizedBox(height: defaultPadding),
                        ParticipantStat(event: event),
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

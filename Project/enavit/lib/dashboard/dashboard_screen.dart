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
          PopupMenuButton<String>(
            onSelected: (String result) async {
              if (result == 'Update Expense') {
                Map<String, String>? expenseData = await showDialog<Map<String, String>>(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController descriptionController = TextEditingController();
                    TextEditingController expenseController = TextEditingController();

                    return AlertDialog(
                      title: const Text('Update Expense'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(hintText: "Enter description"),
                          ),
                          TextField(
                            controller: expenseController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: "Enter expense amount"),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop({
                              'description': descriptionController.text,
                              'expense': expenseController.text,
                            });
                          },
                          child: const Text('Submit'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );

                if (expenseData != null && expenseData['description']!.isNotEmpty && expenseData['expense']!.isNotEmpty) {
                  Services service = Services();
                  String response = await service.updateExpense(expenseData,event);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response),
                    ),
                  );
                  print(expenseData);
                }
              } else if (result == 'Update Expected Revenue') {
                String? userInput = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController inputController = TextEditingController();

                    return AlertDialog(
                      title: const Text('Update Expected Revenue'),
                      content: TextField(
                        controller: inputController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "Enter expected revenue"),
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
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );

                if (userInput != null && userInput.isNotEmpty) {
                  Services service = Services();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

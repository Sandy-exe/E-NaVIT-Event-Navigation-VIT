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
              } else if (result == 'View Expense') {
                List<Map<dynamic,dynamic>> expenses = await Services().getExpenses(event);
                                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Expenses'),
                      content: FutureBuilder<List<Map<dynamic, dynamic>>>(
                        future: Services().getExpenses(event),
                        builder: (BuildContext context, AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(
                              width: double.maxFinite,
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const SizedBox(
                              width: double.maxFinite,
                              height: 200,
                              child: Center(
                                child: Text('Error retrieving expenses'),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SizedBox(
                              width: double.maxFinite,
                              height: 200,
                              child: Center(
                                child: Text('No expenses found'),
                              ),
                            );
                          } else {
                            List<Map<dynamic, dynamic>> expenses = snapshot.data!;
                            Map<dynamic, dynamic> totalExpense = expenses.last;
                            expenses.removeLast();
                
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: expenses.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                          child: ListTile(
                                            title: Text(expenses[index]['description']),
                                            subtitle: Text('Amount: ${expenses[index]['expense']}'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Total Expense: ${totalExpense['Total_Expense']}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
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
              const PopupMenuItem<String>(
                value: 'View Expense',
                child: Text('View Expense'),
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

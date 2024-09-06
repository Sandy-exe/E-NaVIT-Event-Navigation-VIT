import 'dart:convert';

import 'package:enavit_main/Data/secure_storage.dart';
import 'package:enavit_main/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/models/og_models.dart';

class SEVENTAnnouncement extends StatefulWidget {
  final Event event;
  final String userId;
  final String userName;

  const SEVENTAnnouncement(
      {super.key,
      required this.event,
      required this.userId,
      required this.userName});

  @override
  State<SEVENTAnnouncement> createState() => _SEVENTAnnouncementState();
}

class _SEVENTAnnouncementState extends State<SEVENTAnnouncement> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _announcementController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.event.eventId);
  }

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  Future<void> sendAnnouncement() async {
    Services services = Services();

    await services.addEventannouncementDetails(
      EventAnnoucenments(
        eventId: widget.event.eventId,
        announcement: _announcementController.text,
        announcementId: "",
        dateTime: DateTime.now(),
        userId: widget.userId,
        userName: widget.userName,
        eventName: widget.event.eventName,
        clubId: widget.event.clubId,
      ),
    );
  }

  Future<void> initPrefs() async {
    // Add any asynchronous operations you need to perform here
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('An error occurred!'),
          ); // Show error message if any error occurs
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Event Announcement"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _announcementController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Announcement',
                        labelStyle: const TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an announcement';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                // Perform save operation
                                await sendAnnouncement();
                                Navigator.pop(context);

                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Post Announcement'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

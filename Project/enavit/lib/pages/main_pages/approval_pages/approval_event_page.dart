import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';

class ApprovalPage extends StatefulWidget {
  final Approval approval;
  const ApprovalPage({super.key, required this.approval});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  //final TextEditingController _extraInfoTEC = TextEditingController();
  final TextEditingController _discussionPointsTEC = TextEditingController();
  final TextEditingController _eventTypeTEC = TextEditingController();
  final TextEditingController _eventCategoryTEC = TextEditingController();
  final TextEditingController _fdpProposedByTEC = TextEditingController();
  final TextEditingController _schoolCentreTEC = TextEditingController();
  final TextEditingController _coordinator1TEC = TextEditingController();
  final TextEditingController _coordinator2TEC = TextEditingController();
  final TextEditingController _coordinator3TEC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
                child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text(
              "Create Event",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            TextField(
              controller: _discussionPointsTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'Discussion Points',
                  hintText: 'Enter Discussion Points',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _eventTypeTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'Event Type',
                  hintText: 'Enter Event Type',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _eventCategoryTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'Event Category',
                  hintText: 'Select Event Category',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _fdpProposedByTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'FDP Proposed By',
                  hintText: 'School/Centre',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _schoolCentreTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'School/Centre',
                  hintText: 'Select School/Centre',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _coordinator1TEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'Coordinator 1',
                  hintText: 'Enter Coordinator',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _coordinator2TEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'Coordinator 2',
                  hintText: 'Optional',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: _coordinator3TEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: const Icon(Icons.info),
                  labelText: 'Coordinator 3',
                  hintText: 'Optional',
                  isDense: true),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: () async {
                addEvent();
              },
              child: const Text(
                "Publish event",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
                ),
              ),
        ));
  }

  Future addEvent() async {
    // await uploadImage().whenComplete(() =>
    //     showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    Services services = Services();
    await services.addEvent(
      Event(
        clubId: widget.approval.clubId,
        dateTime: {
          "endTime": widget.approval.dateTime['endTime'],
          "startTime": widget.approval.dateTime['startTime']
        },
        description: widget.approval.description,
        eventId: widget.approval.approvalId,
        eventName: widget.approval.eventName,
        location: widget.approval.location,
        organisers: widget.approval.organisers,
        comments: {"user1": "naice"},
        participants: ["part1", "part2"],
        likes: 100,
        fee: widget.approval.fee,
        eventImageURL: widget.approval.eventImageURL,
        discussionPoints: _discussionPointsTEC.text,
        eventType: _eventTypeTEC.text,
        eventCategory: _eventCategoryTEC.text,
        fdpProposedBy: _fdpProposedByTEC.text,
        schoolCentre: _schoolCentreTEC.text,
        coordinator1: _coordinator1TEC.text,
        coordinator2: _coordinator2TEC.text,
        coordinator3: _coordinator3TEC.text,
      ),
    );
    print("'ok");

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Upload Status'),
            content: Text('Event added successfully'),
          );
        },
      );

      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/approver_index", (r) => false);
        });
      }

      print("ok");
    }

    // ValueListenableBuilder<File?>(
    //   valueListenable: imageNotifier,
    //   builder: (context, value, child) {
    //     return _buildImage(context, value);
    //   },
    // );
  }
}

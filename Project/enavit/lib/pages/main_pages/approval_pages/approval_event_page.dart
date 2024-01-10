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
  final TextEditingController _extraInfoTEC = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          TextField(
                  controller: _extraInfoTEC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: const Icon(Icons.info),
                      labelText: 'Extra info',
                      hintText: 'Give extra info',
                      isDense: true),
                  style: const TextStyle(fontSize: 16),
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
        extraInfo: _extraInfoTEC.text,
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
              context, "/organiser_index", (r) => false);
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

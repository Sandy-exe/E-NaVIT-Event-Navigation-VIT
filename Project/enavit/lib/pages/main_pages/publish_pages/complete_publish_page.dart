import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'dart:io';

class PublishEventPage extends StatefulWidget {
  final Approval approval;
  const PublishEventPage({super.key, required this.approval});

  @override
  _PublishEventPageState createState() => _PublishEventPageState();
}

class _PublishEventPageState extends State<PublishEventPage> {
  final TextEditingController _startTimeTEC = TextEditingController();
  final TextEditingController _endTimeTEC = TextEditingController();
  late TextEditingController _eventNameTEC = TextEditingController();
  late TextEditingController _locationTEC = TextEditingController();
  late TextEditingController _organisersTEC = TextEditingController();
  late TextEditingController _approvedTEC = TextEditingController();
  late TextEditingController _discussionPointsTEC = TextEditingController();
  late TextEditingController _eventTypeTEC = TextEditingController();
  late TextEditingController _eventCategoryTEC = TextEditingController();
  late TextEditingController _fdpProposedByTEC = TextEditingController();
  late TextEditingController _schoolCentreTEC = TextEditingController();
  late TextEditingController _coordinator1TEC = TextEditingController();
  late TextEditingController _coordinator2TEC = TextEditingController();
  late TextEditingController _coordinator3TEC = TextEditingController();
  late TextEditingController _budgetTEC = TextEditingController();
  late TextEditingController _clubIdTEC = TextEditingController();
  late TextEditingController _dateTimeTEC = TextEditingController();
  late TextEditingController _descriptionTEC = TextEditingController();
  late TextEditingController _approvalIdTEC = TextEditingController();
  final TextEditingController _eventFeeTEC = TextEditingController();
  final TextEditingController _eventImageURL = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  String? downloadUrl;
  final imageNotifier = ValueNotifier<File?>(null);

  Future ImagePickerMethod() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageNotifier.value = _image;
      } else {
        showSnackBar("No Image Selected", const Duration(milliseconds: 1000));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _clubIdTEC = TextEditingController(text: widget.approval.clubId);
    _dateTimeTEC =
        TextEditingController(text: widget.approval.dateTime.toString());
    _descriptionTEC = TextEditingController(text: widget.approval.description);
    _approvalIdTEC = TextEditingController(text: widget.approval.approvalId);
    _eventNameTEC = TextEditingController(text: widget.approval.eventName);
    _locationTEC = TextEditingController(text: widget.approval.location);
    _organisersTEC =
        TextEditingController(text: widget.approval.organisers.join(', '));
    _approvedTEC =
        TextEditingController(text: widget.approval.approved.toString());
    _discussionPointsTEC =
        TextEditingController(text: widget.approval.discussionPoints);
    _eventTypeTEC = TextEditingController(text: widget.approval.eventType);
    _eventCategoryTEC =
        TextEditingController(text: widget.approval.eventCategory);
    _fdpProposedByTEC =
        TextEditingController(text: widget.approval.fdpProposedBy);
    _schoolCentreTEC =
        TextEditingController(text: widget.approval.schoolCentre);
    _coordinator1TEC =
        TextEditingController(text: widget.approval.coordinator1);
    _coordinator2TEC =
        TextEditingController(text: widget.approval.coordinator2);
    _coordinator3TEC =
        TextEditingController(text: widget.approval.coordinator3);
    _budgetTEC = TextEditingController(text: widget.approval.budget);
    
    _startTimeTEC.text = formatDate(widget.approval.dateTime["startTime"]);
    _endTimeTEC.text = formatDate(widget.approval.dateTime["endTime"]);
  }

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();

    String year = date.year.toString().padLeft(4, '0');
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    String second = date.second.toString().padLeft(2, '0');

    // Return the date and time in ISO 8601 format
    return "$year-$month-$day $hour:$minute:$second";
  }
  

  Future uploadImage() async {
    SecureStorage secureStorage = SecureStorage();
    String userData =
        await secureStorage.reader(key: "currentUserData") ?? "null";

    if (userData == "null") return;
    Map<String, dynamic> currentUserData = jsonDecode(userData);
    String clubId = currentUserData["clubs"][0];
    String userId = currentUserData["userid"];
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("$clubId/images")
        .child("$uniqueFileName.userID$userId");
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() async {
      downloadUrl = await ref.getDownloadURL();
      _eventImageURL.text = downloadUrl!;
    });
    // var imageURL = "";
  }

  showSnackBar(String message, Duration d) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: d.inSeconds),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Approval"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Approval",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _clubIdTEC,
                    decoration: const InputDecoration(
                      labelText: 'Club ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _startTimeTEC,
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                    ),
                    // Add any other properties as needed
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _endTimeTEC,
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                    ),
                    // Add any other properties as needed
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _descriptionTEC,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _approvalIdTEC,
                    decoration: const InputDecoration(
                      labelText: 'Approval ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _eventNameTEC,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _locationTEC,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _organisersTEC,
                    decoration: const InputDecoration(
                      labelText: 'Organisers',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _approvedTEC,
                    decoration: const InputDecoration(
                      labelText: 'Approved',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _discussionPointsTEC,
                    decoration: const InputDecoration(
                      labelText: 'Discussion Points',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _eventTypeTEC,
                    decoration: const InputDecoration(
                      labelText: 'Event Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _eventCategoryTEC,
                    decoration: const InputDecoration(
                      labelText: 'Event Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _fdpProposedByTEC,
                    decoration: const InputDecoration(
                      labelText: 'FDP Proposed By',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _schoolCentreTEC,
                    decoration: const InputDecoration(
                      labelText: 'School/Centre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _coordinator1TEC,
                    decoration: const InputDecoration(
                      labelText: 'Coordinator 1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _coordinator2TEC,
                    decoration: const InputDecoration(
                      labelText: 'Coordinator 2',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _coordinator3TEC,
                    decoration: const InputDecoration(
                      labelText: 'Coordinator 3',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _budgetTEC,
                    decoration: const InputDecoration(
                      labelText: 'Budget',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () async {
                      ImagePickerMethod();
                    },
                    child: _image == null
                        ? const Text(
                            "Choose Image",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Change Image",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )),
                //view image
                _buildImage(context, _image),
                const SizedBox(
                  height: 32,
                ),
                TextField(
                  controller: _eventFeeTEC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: const Icon(Icons.money),
                      labelText: 'Event fees',
                      hintText: 'Enter event fee',
                      isDense: true),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
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
                    "Add event",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }

  Widget _buildImage(BuildContext context, [File? image]) {
    if (image != null) {
      return Image.file(image);
    } else {
      return const Text('Take a picture');
    }
  }

  Future addEvent() async {
    // await uploadImage().whenComplete(() =>
    //     showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    await uploadImage().whenComplete(() =>
        showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    Services services = Services();
    await services.closeApproval(widget.approval.approvalId);
    await services.addEvent(
      Event(
        clubId: _clubIdTEC.text,
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
        fee: _eventFeeTEC.text, //widget.approval.fee,
        eventImageURL: _eventImageURL.text, //widget.approval.eventImageURL,
        discussionPoints: widget.approval.discussionPoints,
        eventType: widget.approval.eventType,
        eventCategory: widget.approval.eventCategory,
        fdpProposedBy: widget.approval.fdpProposedBy,
        schoolCentre: widget.approval.schoolCentre,
        coordinator1: widget.approval.coordinator1,
        coordinator2: widget.approval.coordinator2,
        coordinator3: widget.approval.coordinator3,
        attendancePresent: "0",
        issues: {},
        expense: "0",
        revenue: "0",
        budget: widget.approval.budget,
        expectedRevenue: "0",
      ),
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Upload Status'),
            content: Text('Event published successfully'),
          );
        },
      );

      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () async {
          SecureStorage secureStorage = SecureStorage();
          String userData =
              await secureStorage.reader(key: "currentUserData") ?? "null";
          //if (userData == "null") return;
          Map<String, dynamic> currentUserData = jsonDecode(userData);
          if (currentUserData["role"] == 1) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/organiser_index", (r) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, "/approver_index", (r) => false);
          }
        });
      }
    }

  }


  dateTimePickerStartWidget(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      _startTimeTEC.text = "$date"; //date as String;
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  dateTimePickerEndWidget(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      _endTimeTEC.text = "$date"; //date as String;
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}

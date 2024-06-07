import 'dart:convert';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'dart:io';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final TextEditingController _startTimeTEC = TextEditingController();
  final TextEditingController _endTimeTEC = TextEditingController();
  final TextEditingController _eventNameTEC = TextEditingController();
  final TextEditingController _eventDescriptionTEC = TextEditingController();
  final TextEditingController _eventLocationTEC = TextEditingController();
  final TextEditingController _eventImageURL = TextEditingController();
  final TextEditingController _discussionPointsTEC = TextEditingController();
  final TextEditingController _eventTypeTEC = TextEditingController();
  final TextEditingController _eventCategoryTEC = TextEditingController();
  final TextEditingController _fdpProposedByTEC = TextEditingController();
  final TextEditingController _schoolCentreTEC = TextEditingController();
  final TextEditingController _coordinator1TEC = TextEditingController();
  final TextEditingController _coordinator2TEC = TextEditingController();
  final TextEditingController _coordinator3TEC = TextEditingController();
  final TextEditingController _budgetTEC = TextEditingController();

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
        title: Text('Event Creation'),
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
                  TextField(
                    controller: _eventNameTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.event),
                        labelText: 'Event name',
                        hintText: 'Enter event name',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _eventDescriptionTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.description),
                        labelText: 'Event description',
                        hintText: 'Enter event description',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // TextField(
                  //   controller: _eventClubTEC,
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(100),
                  //       ),
                  //       prefixIcon: const Icon(Icons.house),
                  //       labelText: 'Club',
                  //       hintText: 'Enter club ID',
                  //       isDense: true),
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _eventLocationTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.location_pin),
                        labelText: 'Event location',
                        hintText: 'Enter event location',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        child: TextField(
                          controller: _startTimeTEC,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                            dateTimePickerStartWidget(context);
                          },
                          child: const Text(
                            'Pick start time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        child: TextField(
                          controller: _endTimeTEC,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                            dateTimePickerEndWidget(context);
                          },
                          child: const Text(
                            'Pick end time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // TextField(
                  //   controller: _eventApproverTEC,
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(100),
                  //       ),
                  //       prefixIcon: const Icon(Icons.person),
                  //       labelText: 'Approver',
                  //       hintText: 'Enter approver ID',
                  //       isDense: true),
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(
                    height: 16,
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
                    height: 16,
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
                    height: 16,
                  ),
                  TextField(
                    controller: _eventCategoryTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.info),
                        labelText: 'Event Category',
                        hintText: 'Enter Event Category',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _fdpProposedByTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.info),
                        labelText: 'Proposed By',
                        hintText: 'Enter FDP Proposer',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _schoolCentreTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.info),
                        labelText: 'School Centre',
                        hintText: 'Enter School Centre',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _coordinator1TEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Coordinator 1',
                        hintText: 'Enter Coordinator',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _coordinator2TEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Coordinator 2',
                        hintText: 'Enter Coordinator',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _coordinator3TEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Coordinator 3',
                        hintText: 'Enter Coordinator',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _budgetTEC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.money),
                        labelText: 'Budget',
                        hintText: 'Enter Budget',
                        isDense: true),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 260,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        // Implement event creation logic here
                        addApproval();
                      },
                      child: const Text(
                        'Create Approval Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  //create function to add approval using service and check if approval is updated and user approval event field is getting updated
  Future addApproval() async {
    
    SecureStorage secureStorage = SecureStorage();
    String userData =
        await secureStorage.reader(key: "currentUserData") ?? "null";

    if (userData == "null") return;
    Map<String, dynamic> currentUserData = jsonDecode(userData);
    print(currentUserData);
    String clubId = currentUserData["clubIds"][0];

    Club clubDetail = await Services().getOrganizerClubDetails();
    String approverId = clubDetail.approvers[0];

    List<String> approverIDs = [approverId,currentUserData["userid"]];


    Services services = Services();
    await services.addApproval(
      Approval(
        clubId: clubId,
        dateTime: {
          "endTime": DateTime.parse(_endTimeTEC.text),
          "startTime": DateTime.parse(_startTimeTEC.text)
        },
        description: _eventDescriptionTEC.text,
        approvalId: "IDS",
        eventName: _eventNameTEC.text,
        location: _eventLocationTEC.text,
        organisers: approverIDs,
        approved: 0,
        discussionPoints: _discussionPointsTEC.text,
        eventType: _eventTypeTEC.text,
        eventCategory: _eventCategoryTEC.text,
        fdpProposedBy: _fdpProposedByTEC.text,
        schoolCentre: _schoolCentreTEC.text,
        coordinator1: _coordinator1TEC.text,
        coordinator2: _coordinator2TEC.text,
        coordinator3: _coordinator3TEC.text,
        budget: _budgetTEC.text,
      ),
    );
    print("inside");
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Upload Status'),
            content: Text('Approval created successfully'),
          );
        },
      );

      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/organiser_index", (r) => false);
        });
      }
    }
  }

  void dateTimePickerStartWidget(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2023, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      onChanged: (date) {},
      onConfirm: (date) {
        _startTimeTEC.text = date.toString();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  void dateTimePickerEndWidget(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2023, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      onChanged: (date) {},
      onConfirm: (date) {
        _endTimeTEC.text = date.toString();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }
}

import 'dart:convert';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
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
  final TextEditingController _eventFeeTEC = TextEditingController();
  late String _eventClubTEC;


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

  Future uploadImage_updateClub() async {
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

    _eventClubTEC = clubId;
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () async {
                      final List<DateTime>? dateTime =
                          await showOmniDateTimeRangePicker(context: context);

                      if (dateTime == null) return;

                      String formattedTime1 =
                          DateFormat('kk:mm').format(dateTime[0]);
                      String formattedDate1 =
                          DateFormat('yyyy-MM-dd').format(dateTime[0]);

                      String formattedTime2 =
                          DateFormat('kk:mm').format(dateTime[1]);
                      String formattedDate2 =
                          DateFormat('yyyy-MM-dd').format(dateTime[1]);

                      _startTimeTEC.text = "$formattedDate1 $formattedTime1";
                      _endTimeTEC.text = "$formattedDate2 $formattedTime2";
                    },
                    child: const Text(
                      'Pick Time Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start Date and Time
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _startTimeTEC,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Start Date and Time',
                            border: OutlineInputBorder(),
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
                      Expanded(
                        child: TextField(
                          controller: _endTimeTEC,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'End Date and Time',
                            border: OutlineInputBorder(),
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
                    height: 16,
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
                    height: 30,
                  ),
                  SizedBox(
                    width: 230,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        // Implement event creation logic here
                        addEvent();
                      },
                      child: const Text(
                        'Publish Event',
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


  Widget _buildImage(BuildContext context, [File? image]) {
    if (image != null) {
      return Image.file(image);
    } else {
      return const Text('Take a picture');
    }
  }


  Future addEvent() async {
    // await uploadImage_updateClub().whenComplete(() =>
    //     showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    await uploadImage_updateClub().whenComplete(() =>
        showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    Services services = Services();
    
    //await services.closeApproval(widget.approval.approvalId);
    await services.addEvent(
      Event(
        clubId: _eventClubTEC,
        dateTime: {
          "endTime": DateTime.parse(_endTimeTEC.text),
          "startTime": DateTime.parse(_startTimeTEC.text),
        },
        description: _eventDescriptionTEC.text,
        eventId: _eventNameTEC.text,
        eventName: _eventNameTEC.text,
        location: _eventLocationTEC.text,
        organisers: [],
        comments: {"user1": "naice"},
        participants: ["part1", "part2"],
        likes: 100,
        fee: _eventFeeTEC.text, //widget.approval.fee,
        eventImageURL: _eventImageURL.text, //widget.approval.eventImageURL,
        discussionPoints: _discussionPointsTEC.text,
        eventType: _eventTypeTEC.text,
        eventCategory: _eventCategoryTEC.text,
        fdpProposedBy: _fdpProposedByTEC.text,
        schoolCentre: _schoolCentreTEC.text,
        coordinator1: _coordinator1TEC.text,
        coordinator2: _coordinator2TEC.text,
        coordinator3: _coordinator3TEC.text,
        attendancePresent: "0",
        issues: {},
        expense: "0",
        revenue: "0",
        budget: _budgetTEC.text,
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















  Future addApproval() async {
    Services services = Services();
    await services.addApproval(
      Approval(
        clubId: _eventClubTEC,
        dateTime: {
          "endTime": DateTime.parse(_endTimeTEC.text),
          "startTime": DateTime.parse(_startTimeTEC.text)
        },
        description: _eventDescriptionTEC.text,
        approvalId: _eventNameTEC.text,
        eventName: _eventNameTEC.text,
        location: _eventLocationTEC.text,
        organisers: [],
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

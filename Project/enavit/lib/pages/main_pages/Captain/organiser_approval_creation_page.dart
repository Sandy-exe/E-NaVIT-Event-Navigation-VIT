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
  bool _isLoading = false; // Loading state

  Future<void> ImagePickerMethod() async {
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

  // Future<void> uploadImage() async {
  //   SecureStorage secureStorage = SecureStorage();
  //   String userData =
  //       await secureStorage.reader(key: "currentUserData") ?? "null";

  //   if (userData == "null") return;
  //   Map<String, dynamic> currentUserData = jsonDecode(userData);
  //   String clubId = currentUserData["clubs"][0];
  //   String userId = currentUserData["userid"];
  //   String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("$clubId/images")
  //       .child("$uniqueFileName.userID$userId");
  //   UploadTask uploadTask = ref.putFile(_image!);
  //   await uploadTask.whenComplete(() async {
  //     downloadUrl = await ref.getDownloadURL();
  //     _eventImageURL.text = downloadUrl!;
  //   });
  // }

  void showSnackBar(String message, Duration d) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: d.inSeconds),
    ));
  }

  Future<void> addApproval() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    SecureStorage secureStorage = SecureStorage();
    String userData =
        await secureStorage.reader(key: "currentUserData") ?? "null";

    if (userData == "null") return;
    Map<String, dynamic> currentUserData = jsonDecode(userData);
    String clubId = currentUserData["clubIds"][0];

    Club clubDetail = await Services().getOrganizerClubDetails();
    String approverId = clubDetail.approvers[0];

    List<String> approverIDs = [approverId, currentUserData["userid"]];

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

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/organiser_index", (r) => false);
      });
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String label,
    String hint,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }

  Widget _buildReadOnlyTextField(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_today),
        labelText: label,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Creation'),
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
                  _buildTextField(
                    _eventNameTEC,
                    Icons.event,
                    'Event name',
                    'Enter event name',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _eventDescriptionTEC,
                    Icons.description,
                    'Event description',
                    'Enter event description',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _eventLocationTEC,
                    Icons.location_pin,
                    'Event location',
                    'Enter event location',
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
                  _buildReadOnlyTextField(_startTimeTEC, 'Start Date and Time'),
                  const SizedBox(height: 16),
                  _buildReadOnlyTextField(_endTimeTEC, 'End Date and Time'),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _discussionPointsTEC,
                    Icons.list,
                    'Discussion points',
                    'Enter discussion points',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _eventTypeTEC,
                    Icons.category,
                    'Event type',
                    'Enter event type',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _eventCategoryTEC,
                    Icons.category,
                    'Event category',
                    'Enter event category',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _fdpProposedByTEC,
                    Icons.person,
                    'FDP Proposed By',
                    'Enter FDP proposed by',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _schoolCentreTEC,
                    Icons.school,
                    'School/ Centre',
                    'Enter school/centre',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _coordinator1TEC,
                    Icons.person,
                    'Coordinator 1',
                    'Enter coordinator 1',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _coordinator2TEC,
                    Icons.person,
                    'Coordinator 2',
                    'Enter coordinator 2',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _coordinator3TEC,
                    Icons.person,
                    'Coordinator 3',
                    'Enter coordinator 3',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    _budgetTEC,
                    Icons.money,
                    'Budget',
                    'Enter budget',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null // Disable the button when loading
                        : () async {
                            if (_startTimeTEC.text.isEmpty ||
                                _endTimeTEC.text.isEmpty ||
                                _eventNameTEC.text.isEmpty ||
                                _eventDescriptionTEC.text.isEmpty ||
                                _eventLocationTEC.text.isEmpty ||
                                _eventTypeTEC.text.isEmpty ||
                                _eventCategoryTEC.text.isEmpty ||
                                _fdpProposedByTEC.text.isEmpty ||
                                _schoolCentreTEC.text.isEmpty ||
                                _budgetTEC.text.isEmpty) {
                              showSnackBar("Please fill all fields",
                                  const Duration(seconds: 1));
                            } else {
                              await addApproval();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator() // Show loading indicator
                        : const Text(
                            'Create Approval Request',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
}

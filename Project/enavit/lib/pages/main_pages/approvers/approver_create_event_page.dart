import 'dart:convert';
import 'dart:io';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:intl/intl.dart';
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
  bool _isLoading = false; // Loading state variable

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          imageNotifier.value = _image;
        });
      } else {
        _showSnackBar("No Image Selected");
      }
    } catch (e) {
      _showSnackBar("Error picking image");
    }
  }

  Future<void> _uploadImage() async {
    try {
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
    } catch (e) {
      _showSnackBar("Error uploading image");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  Future<void> _createEvent() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      await _uploadImage();
      Services services = Services();

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
          comments: {},
          participants: [],
          likes: 0,
          fee: _eventFeeTEC.text,
          eventImageURL: _eventImageURL.text,
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

        Future.delayed(const Duration(seconds: 2), () async {
          SecureStorage secureStorage = SecureStorage();
          String userData =
              await secureStorage.reader(key: "currentUserData") ?? "null";
          Map<String, dynamic> currentUserData = jsonDecode(userData);
          String route = currentUserData["role"] == 1
              ? "/organiser_index"
              : "/approver_index";
          Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
        });
      }
    } catch (e) {
      _showSnackBar("Error creating event");
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Creation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Create Approval",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 80),
              _buildTextField(
                  _eventNameTEC, Icons.event, 'Event name', 'Enter event name'),
              const SizedBox(height: 16),
              _buildTextField(_eventDescriptionTEC, Icons.description,
                  'Event description', 'Enter event description'),
              const SizedBox(height: 16),
              _buildTextField(_eventLocationTEC, Icons.location_pin,
                  'Event location', 'Enter event location'),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
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
                child: const Text('Pick Time Range',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: 16),
              _buildReadOnlyTextField(_startTimeTEC, 'Start Date and Time'),
              const SizedBox(height: 16),
              _buildReadOnlyTextField(_endTimeTEC, 'End Date and Time'),
              const SizedBox(height: 16),
              _buildTextField(_discussionPointsTEC, Icons.info,
                  'Discussion Points', 'Enter Discussion Points'),
              const SizedBox(height: 16),
              _buildTextField(
                  _eventTypeTEC, Icons.info, 'Event Type', 'Enter Event Type'),
              const SizedBox(height: 16),
              _buildTextField(_eventCategoryTEC, Icons.info, 'Event Category',
                  'Enter Event Category'),
              const SizedBox(height: 16),
              _buildTextField(_fdpProposedByTEC, Icons.info, 'FDP Proposed By',
                  'Enter FDP Proposed By'),
              const SizedBox(height: 16),
              _buildTextField(_schoolCentreTEC, Icons.info, 'School Centre',
                  'Enter School Centre'),
              const SizedBox(height: 16),
              _buildTextField(_coordinator1TEC, Icons.info, 'Coordinator 1',
                  'Enter Coordinator 1'),
              const SizedBox(height: 16),
              _buildTextField(_coordinator2TEC, Icons.info, 'Coordinator 2',
                  'Enter Coordinator 2'),
              const SizedBox(height: 16),
              _buildTextField(_coordinator3TEC, Icons.info, 'Coordinator 3',
                  'Enter Coordinator 3'),
              const SizedBox(height: 16),
              _buildTextField(
                  _budgetTEC, Icons.attach_money, 'Budget', 'Enter Budget'),
              const SizedBox(height: 16),
              _buildTextField(
                  _eventFeeTEC, Icons.attach_money, 'Event Fee', 'Enter Fee'),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
                onPressed: _pickImage,
                child: const Text('Upload Image',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: 16),
              _image != null
                  ? Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
                onPressed: _isLoading ? null : _createEvent,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Event',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
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
}

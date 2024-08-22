import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class PublishEventPage extends StatefulWidget {
  final Approval approval;

  const PublishEventPage({super.key, required this.approval});

  @override
  _PublishEventPageState createState() => _PublishEventPageState();
}

class _PublishEventPageState extends State<PublishEventPage> {
  bool _isLoading = false;
  final TextEditingController _startTimeTEC = TextEditingController();
  final TextEditingController _endTimeTEC = TextEditingController();
  final TextEditingController _eventNameTEC = TextEditingController();
  final TextEditingController _locationTEC = TextEditingController();
  final TextEditingController _organisersTEC = TextEditingController();
  final TextEditingController _approvedTEC = TextEditingController();
  final TextEditingController _discussionPointsTEC = TextEditingController();
  final TextEditingController _eventTypeTEC = TextEditingController();
  final TextEditingController _eventCategoryTEC = TextEditingController();
  final TextEditingController _fdpProposedByTEC = TextEditingController();
  final TextEditingController _schoolCentreTEC = TextEditingController();
  final TextEditingController _coordinator1TEC = TextEditingController();
  final TextEditingController _coordinator2TEC = TextEditingController();
  final TextEditingController _coordinator3TEC = TextEditingController();
  final TextEditingController _budgetTEC = TextEditingController();
  final TextEditingController _clubIdTEC = TextEditingController();
  final TextEditingController _descriptionTEC = TextEditingController();
  final TextEditingController _approvalIdTEC = TextEditingController();
  final TextEditingController _eventFeeTEC = TextEditingController();
  final TextEditingController _eventImageURL = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  String? downloadUrl;
  final imageNotifier = ValueNotifier<File?>(null);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _clubIdTEC.text = widget.approval.clubId;
    _descriptionTEC.text = widget.approval.description;
    _approvalIdTEC.text = widget.approval.approvalId;
    _eventNameTEC.text = widget.approval.eventName;
    _locationTEC.text = widget.approval.location;
    _organisersTEC.text = widget.approval.organisers.join(', ');
    _approvedTEC.text = widget.approval.approved.toString();
    _discussionPointsTEC.text = widget.approval.discussionPoints;
    _eventTypeTEC.text = widget.approval.eventType;
    _eventCategoryTEC.text = widget.approval.eventCategory;
    _fdpProposedByTEC.text = widget.approval.fdpProposedBy;
    _schoolCentreTEC.text = widget.approval.schoolCentre;
    _coordinator1TEC.text = widget.approval.coordinator1;
    _coordinator2TEC.text = widget.approval.coordinator2;
    _coordinator3TEC.text = widget.approval.coordinator3;
    _budgetTEC.text = widget.approval.budget;
    _startTimeTEC.text = formatDate(widget.approval.dateTime["startTime"]);
    _endTimeTEC.text = formatDate(widget.approval.dateTime["endTime"]);
  }

  String formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date.toDate());
    } else if (date is DateTime) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }
    return '';
  }

  Future<void> ImagePickerMethod() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageNotifier.value = _image;
      });
    } else {
      showSnackBar("No Image Selected", const Duration(milliseconds: 1000));
    }
  }

  Future<void> uploadImage() async {
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

  void showSnackBar(String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Approval",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 80),
              _buildFormFields(),
              const SizedBox(height: 32),
              _buildImagePicker(),
              const SizedBox(height: 32),
              _buildEventFeeField(),
              
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: _isLoading ? null : addEvent,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                    "Add Event",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(_clubIdTEC, 'Club ID'),
                SizedBox(height: 16.0),
        _buildTextField(_descriptionTEC, 'Description'),
                SizedBox(height: 16.0),
        _buildTextField(_approvalIdTEC, 'Approval ID'),
                SizedBox(height: 16.0),
        _buildTextField(_eventNameTEC, 'Event Name'),

        const SizedBox(height: 16),
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

            String formattedTime1 = DateFormat('kk:mm').format(dateTime[0]);
            String formattedDate1 =
                DateFormat('yyyy-MM-dd').format(dateTime[0]);

            String formattedTime2 = DateFormat('kk:mm').format(dateTime[1]);
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
                _buildTextField(_startTimeTEC, "Start Time"),
        SizedBox(height: 16.0),
        _buildTextField(_endTimeTEC, "End Time"),
        SizedBox(height: 16.0),
        _buildTextField(_locationTEC, 'Location'),
        SizedBox(height: 16.0),
        _buildTextField(_organisersTEC, 'Organisers'),
        SizedBox(height: 16.0),
        _buildTextField(_approvedTEC, 'Approved'),
        SizedBox(height: 16.0),
        _buildTextField(_discussionPointsTEC, 'Discussion Points'),
        SizedBox(height: 16.0),
        _buildTextField(_eventTypeTEC, 'Event Type'),
        SizedBox(height: 16.0),
        _buildTextField(_eventCategoryTEC, 'Event Category'),
        SizedBox(height: 16.0),
        _buildTextField(_fdpProposedByTEC, 'FDP Proposed By'),
        SizedBox(height: 16.0),
        _buildTextField(_schoolCentreTEC, 'School/Centre'),
        SizedBox(height: 16.0),
        _buildTextField(_coordinator1TEC, 'Coordinator 1'),
        SizedBox(height: 16.0),
        _buildTextField(_coordinator2TEC, 'Coordinator 2'),
        SizedBox(height: 16.0),
        _buildTextField(_coordinator3TEC, 'Coordinator 3'),
        SizedBox(height: 16.0),
        _buildTextField(_budgetTEC, 'Budget'),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return ValueListenableBuilder<File?>(
      valueListenable: imageNotifier,
      builder: (context, image, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Event Image"),
            const SizedBox(height: 10),
            image == null
                ? const Text("No image selected")
                : Image.file(image, height: 150),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ImagePickerMethod,
              child: const Text("Select Image"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventFeeField() {
    return TextField(
      controller: _eventFeeTEC,
      decoration: InputDecoration(
        labelText: "Event Fee",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future addEvent() async {
    setState(() {
      _isLoading = true;
    });
    
    // await uploadImage().whenComplete(() =>
    //     showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    try{
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
        comments: {},
        participants: [],
        likes: 0,
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
        attendancePresent: [],
        issues: {},
        expense: [],
        revenue: "0",
        budget: widget.approval.budget,
        expectedRevenue: "0",
      ),
    );
    }finally{
      setState(() {
        _isLoading = false;
      });
    }

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
}

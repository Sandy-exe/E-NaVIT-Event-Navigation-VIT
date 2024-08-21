import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
class ApprovalPage extends StatefulWidget {
  final Approval approval;
  const ApprovalPage({super.key, required this.approval});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  final TextEditingController _startTimeTEC = TextEditingController();
  final TextEditingController _endTimeTEC = TextEditingController();
  final TextEditingController _eventNameTEC = TextEditingController();
  final TextEditingController _eventDescriptionTEC = TextEditingController();
  final TextEditingController _eventLocationTEC = TextEditingController();
  final TextEditingController _eventApproverTEC = TextEditingController();
  final TextEditingController _eventClubTEC = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _startTimeTEC.text = formatDate(widget.approval.dateTime["startTime"]);
    _endTimeTEC.text = formatDate(widget.approval.dateTime["endTime"]);
    _eventNameTEC.text = widget.approval.eventName;
    _eventDescriptionTEC.text = widget.approval.description;
    _eventLocationTEC.text = widget.approval.location;
    _eventApproverTEC.text = widget.approval.organisers[0];
    _eventClubTEC.text = widget.approval.clubId;
    _discussionPointsTEC.text = widget.approval.discussionPoints;
    _eventTypeTEC.text = widget.approval.eventType;
    _eventCategoryTEC.text = widget.approval.eventCategory;
    _fdpProposedByTEC.text = widget.approval.fdpProposedBy;
    _schoolCentreTEC.text = widget.approval.schoolCentre;
    _coordinator1TEC.text = widget.approval.coordinator1;
    _coordinator2TEC.text = widget.approval.coordinator2;
    _coordinator3TEC.text = widget.approval.coordinator3;
    _budgetTEC.text = widget.approval.budget;  
    _eventNameTEC.text = widget.approval.eventName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Approve Event",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
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
                TextField(
                  controller: _eventClubTEC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: const Icon(Icons.house),
                      labelText: 'Club',
                      hintText: 'Enter club ID',
                      isDense: true),
                  style: const TextStyle(fontSize: 16),
                ),
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
                TextField(
                  controller: _eventApproverTEC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Approver',
                      hintText: 'Enter approver ID',
                      isDense: true),
                  style: const TextStyle(fontSize: 16),
                ),
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
                    approveApproval();
                  },
                  child: const Text(
                    "Approve Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
                    RejectApproval();
                  },
                  child: const Text(
                    "Reject Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
  
  Future RejectApproval() async {
    Services services = Services();
    await services.rejectApproval(widget.approval.approvalId);
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Approval Status'),
            content: Text('Rejected successfully'),
          );
        },
      );

      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/approver_index", (r) => false);
        });
      }
    }
  }

  Future approveApproval() async {
    Services services = Services();
    await services.approveApproval(
      widget.approval.approvalId,
      Approval(
        clubId: widget.approval.clubId,
        dateTime: {
          "endTime": DateTime.parse(_endTimeTEC.text),
          "startTime": DateTime.parse(_startTimeTEC.text)
        },
        description: _eventDescriptionTEC.text,
        approvalId: widget.approval.approvalId,
        eventName: _eventNameTEC.text,
        location: _eventLocationTEC.text,
        organisers: widget.approval.organisers,
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
            title: Text('Approval Status'),
            content: Text('Approved successfully'),
          );
        },
      );

      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/approver_index", (r) => false);
        });
      }
    }
  }

  Future addEvent() async {
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
        comments: {},
        participants: [],
        likes: 0,
        fee: "100",
        eventImageURL: "", 
        discussionPoints: _discussionPointsTEC.text,
        eventType: _eventTypeTEC.text,
        eventCategory: _eventCategoryTEC.text,
        fdpProposedBy: _fdpProposedByTEC.text,
        schoolCentre: _schoolCentreTEC.text,
        coordinator1: _coordinator1TEC.text,
        coordinator2: _coordinator2TEC.text,
        coordinator3: _coordinator3TEC.text,
        attendancePresent: [],
        issues: {},
        expense: "0",
        revenue: "0",
        budget: _budgetTEC.text,
        expectedRevenue: "0",
      ),
    );
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

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
  final TextEditingController _eventFeeTEC = TextEditingController();
  final TextEditingController _eventOrganiserTEC = TextEditingController();
  final TextEditingController _eventClubTEC = TextEditingController();
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

  Future uploadImage() async {
    SecureStorage secureStorage = SecureStorage();
    String userData =
        await secureStorage.reader(key: "currentUserData") ?? "null";
    print(userData);

    if (userData == "null") return;
    Map<String, dynamic> currentUserData = jsonDecode(userData);
    String clubId = currentUserData["clubs"][0];
    String userId = currentUserData["userid"];
    print("entered uploadImage $clubId and $userId");
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("$clubId/images")
        .child("$uniqueFileName.userID$userId");
    print("got ref of destination");
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() async {
      print("upload task entered");
      downloadUrl = await ref.getDownloadURL();
      print("got url $downloadUrl");
      _eventImageURL.text = downloadUrl!;
      print("checking ${_eventImageURL.text}");
    });
    print("outsode upload task func and end of uploadIamge func");
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
    return Container(
      child: Padding(
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
                TextField(
                  controller: _eventOrganiserTEC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Organiser',
                      hintText: 'Enter organiser ID',
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
                    //print("addevent checking $imageURL");
                    //addEvent();
                    addApproval();
                    // addEvent(
                    //   Event(
                    //       clubId: _eventClubTEC.text,
                    //       dateTime: {
                    //         "endTime": DateTime.parse(_endTimeTEC.text),
                    //         "startTime": DateTime.parse(_startTimeTEC.text)
                    //       },
                    //       description: _eventDescriptionTEC.text,
                    //       eventId: _eventNameTEC.text,
                    //       eventName: _eventNameTEC.text,
                    //       location: _eventLocationTEC.text,
                    //       organisers: [_eventOrganiserTEC.text],
                    //       comments: {"user1": "naice"},
                    //       participants: ["part1", "part2"],
                    //       likes: 100,
                    //       fee: _eventFeeTEC.text,
                    //       eventImageURL: _eventImageURL.text,
                    //       ),
                    // );
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

//create function to add approval using service and check if approval is updated and user approval event field is getting updated
  Future addApproval() async {
    await uploadImage().whenComplete(() =>
        showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
    Services services = Services();
    await services.addApproval(
      Approval(
        clubId: _eventClubTEC.text,
        dateTime: {
          "endTime": DateTime.parse(_endTimeTEC.text),
          "startTime": DateTime.parse(_startTimeTEC.text)
        },
        description: _eventDescriptionTEC.text,
        approvalId: _eventNameTEC.text,
        eventName: _eventNameTEC.text,
        location: _eventLocationTEC.text,
        organisers: [_eventOrganiserTEC.text],
        comments: {"user1": "naice"},
        participants: ["part1", "part2"],
        likes: 100,
        fee: _eventFeeTEC.text,
        eventImageURL: _eventImageURL.text,
        approved: 0,
      ),
    );
    print("'ok");

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

      print("ok");
    }

    ValueListenableBuilder<File?>(
      valueListenable: imageNotifier,
      builder: (context, value, child) {
        return _buildImage(context, value);
      },
    );
  }

  //Future addEvent(Event event) async {
  // Future addEvent() async {
  //   await uploadImage().whenComplete(() =>
  //       showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
  //   Services services = Services();
  //   await services.addEvent(
  //     Event(
  //       clubId: _eventClubTEC.text,
  //       dateTime: {
  //         "endTime": DateTime.parse(_endTimeTEC.text),
  //         "startTime": DateTime.parse(_startTimeTEC.text)
  //       },
  //       description: _eventDescriptionTEC.text,
  //       eventId: _eventNameTEC.text,
  //       eventName: _eventNameTEC.text,
  //       location: _eventLocationTEC.text,
  //       organisers: [_eventOrganiserTEC.text],
  //       comments: {"user1": "naice"},
  //       participants: ["part1", "part2"],
  //       likes: 100,
  //       fee: _eventFeeTEC.text,
  //       eventImageURL: _eventImageURL.text,
  //     ),
  //   );
  //   print("'ok");

  //   if (mounted) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return const AlertDialog(
  //           title: Text('Upload Status'),
  //           content: Text('Event added successfully'),
  //         );
  //       },
  //     );

  //     if (mounted) {
  //       Future.delayed(const Duration(seconds: 2), () {
  //         Navigator.pushNamedAndRemoveUntil(
  //             context, "/approver_index", (r) => false);
  //       });
  //     }

  //     print("ok");
  //   }

  //   ValueListenableBuilder<File?>(
  //     valueListenable: imageNotifier,
  //     builder: (context, value, child) {
  //       return _buildImage(context, value);
  //     },
  //   );
  // }

  dateTimePickerStartWidget(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      _startTimeTEC.text = "$date"; //date as String;
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  dateTimePickerEndWidget(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      _endTimeTEC.text = "$date"; //date as String;
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}

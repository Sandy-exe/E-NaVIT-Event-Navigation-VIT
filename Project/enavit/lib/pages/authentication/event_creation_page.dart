//import 'dart:html';
//import 'dart:io';

import 'dart:ffi';
import 'dart:io';

import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/thanan_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:firebase_storage/firebase_storage.dart'; // as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
//as datatTimePicker;

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPage();
}

final TextEditingController _startTimeTEC = TextEditingController();
final TextEditingController _endTimeTEC = TextEditingController();

class _EventCreationPage extends State<EventCreationPage> {
  final TextEditingController _eventNameTEC = TextEditingController();
  final TextEditingController _eventDescriptionTEC = TextEditingController();
  final TextEditingController _eventLocationTEC = TextEditingController();
  final TextEditingController _eventFeeTEC = TextEditingController();
  final TextEditingController _eventOrganiserTEC = TextEditingController();
  final TextEditingController _eventClubTEC = TextEditingController();
  final TextEditingController _eventImageURL = TextEditingController();
  //String imageURL = "";

  //DateTime startTime = DateTime(2023);

// firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;

//   File? _photo;
//   final ImagePicker _picker = ImagePicker();

//   Future imgFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future imgFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadFile() async {
//     if (_photo == null) return;
//     final fileName = basename(_photo!.path);
//     final destination = 'files/$fileName';

//     try {
//       final ref = firebase_storage.FirebaseStorage.instance
//           .ref(destination)
//           .child('file/');
//       await ref.putFile(_photo!);
//     } catch (e) {
//       print('error occured');
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _eventNameTEC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.house),
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_pin),
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money),
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
                      width: MediaQuery.of(context).size.width - 190,
                      child: TextField(
                        controller: _startTimeTEC,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          dateTimePickerStartWidget(context);
                        },
                        child: const Text('Pick start time'),
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
                      width: MediaQuery.of(context).size.width - 190,
                      child: TextField(
                        controller: _endTimeTEC,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          dateTimePickerEndWidget(context);
                        },
                        child: const Text('Pick end time'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _eventOrganiserTEC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Organiser',
                      hintText: 'Enter organiser ID',
                      isDense: true),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      print("testing ${file?.path}");
                      if (file == null) return;
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child("images");
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);
                      var imageURL = "";
                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        // setState(() async {
                        //     imageURL = await referenceImageToUpload.getDownloadURL();
                        // });
                        _eventImageURL.text = await referenceImageToUpload.getDownloadURL();
                        print("checking ${_eventImageURL.text}");
                      } catch (error) {
                        print("false $error");
                      }
                      print("checking outside ${_eventImageURL.text}");
                      // var thanan = ThananServices();
                      // Future<String> future =
                      //     thanan.addImage(uniqueFileName, file);
                      // future.then((URL) {
                      //   imageURL = URL;
                      //   print("image check ${imageURL}");
                      // });
                      // imageURL = "vfvfv";
                    },
                    child: const Text("Choose Image")),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () async {
                    //print("addevent checking $imageURL");
                    addEvent(
                      Event(
                          clubId: _eventClubTEC.text,
                          dateTime: {
                            "endTime": DateTime.parse(_endTimeTEC.text),
                            "startTime": DateTime.parse(_startTimeTEC.text)
                          },
                          description: _eventDescriptionTEC.text,
                          eventId: _eventNameTEC.text,
                          eventName: _eventNameTEC.text,
                          location: _eventLocationTEC.text,
                          organisers: [_eventOrganiserTEC.text],
                          comments: {"user1": "naice"},
                          participants: ["part1", "part2"],
                          likes: 100,
                          fee: _eventFeeTEC.text,
                          eventImageURL: _eventImageURL.text),
                    );
                  },
                  child: const Text("Add event"),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}

// void setStartTime(BuildContext context) {
//   dateTimePickerWidget(BuildContext context, DateTime time) {
//     DatePicker.showDateTimePicker(context,
//         showTitleActions: true,
//         minTime: DateTime(2018, 3, 5),
//         maxTime: DateTime(2019, 6, 7), onChanged: (date) {
//       print('change $date');
//     }, onConfirm: (date) {
//       _startTimeTEC.text = date as String;
//       //startTime = date;
//       //return date;
//     }, currentTime: DateTime.now(), locale: LocaleType.en);
//   }
// }

Future<void> addEvent(Event event) async {
  var thanan = ThananServices();
  await thanan.addEvent(event);
  // await thanan.addEvent(Event(
  //     clubId: "clubId",
  //     dateTime: {"endTime": DateTime.now(), "startTime": DateTime.now()},
  //     description: "description",
  //     eventId: "Test_Event",
  //     eventName: "Etho pannunga",
  //     location: "You know where",
  //     organisers: ["org1", "org2"],
  //     comments: {"user1": "naice"},
  //     participants: ["part1", "part2"],
  //     likes: 100,
  //     fee: "99.99"));
}

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

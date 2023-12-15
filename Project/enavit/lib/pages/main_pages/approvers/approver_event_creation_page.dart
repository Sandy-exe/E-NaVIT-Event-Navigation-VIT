
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

  Future ImagePickerMethod () async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImage().whenComplete(showSnackBar("Image Uploaded", const Duration(milliseconds: 1000)));
      } else {
        showSnackBar("No Image Selected", const Duration(milliseconds: 1000));
      }
    });
  }

  Future uploadImage() async {
    
    SecureStorage secureStorage = SecureStorage();
    String userData = await secureStorage.reader(key: "currentUserData") ?? "null";
    print(userData);
    
    if (userData=="null") return ;
    Map<String,dynamic> currentUserData = jsonDecode(userData);
    String clubId = currentUserData["clubs"][0];
    String userId = currentUserData["userid"];

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance.ref().child("$clubId/images").child("$uniqueFileName.userID$userId");
    UploadTask uploadTask = ref.putFile(_image!);
    uploadTask.whenComplete(() async {
    downloadUrl = await ref.getDownloadURL();
    _eventImageURL.text = downloadUrl!;
    print("checking ${_eventImageURL.text}");
    });


    // var imageURL = "";

  }

  showSnackBar(String message,Duration d) {
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

                        ImagePickerMethod();
                        // ImagePicker imagePicker = ImagePicker();
                        // XFile? file = await imagePicker.pickImage(
                        //     source: ImageSource.gallery);
                        // print("testing ${file?.path}");
                        // if (file == null) return;
                        // String uniqueFileName =
                        //     DateTime.now().millisecondsSinceEpoch.toString();
                        // Reference referenceRoot = FirebaseStorage.instance.ref();
                        // Reference referenceDirImages =
                        //     referenceRoot.child("images");
                        // Reference referenceImageToUpload =
                        //     referenceDirImages.child(uniqueFileName);
                        // var imageURL = "";
                        // try {
                        //   await referenceImageToUpload.putFile(File(file.path));
                        //   // setState(() async {
                        //   //     imageURL = await referenceImageToUpload.getDownloadURL();
                        //   // });
                        //   _eventImageURL.text = await referenceImageToUpload.getDownloadURL();
                        //   print("checking ${_eventImageURL.text}");
                        // } catch (error) {
                        //   print("false $error");
                        // }
                        // print("checking outside ${_eventImageURL.text}");
                        // // var thanan = ThananServices();
                        // // Future<String> future =
                        // //     thanan.addImage(uniqueFileName, file);
                        // // future.then((URL) {
                        // //   imageURL = URL;
                        // //   print("image check ${imageURL}");
                        // // });
                        // // imageURL = "vfvfv";
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
                            eventImageURL: _eventImageURL.text
                            ),
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

  Future<void> addEvent(Event event) async {
    print(event);
    

    Services services = Services();
    await services.addEvent(event);
    
    if (mounted) {showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Upload Status'),
          content: Text('Event added successfully'),
          
        );
      },
    );

    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {Navigator.pushNamedAndRemoveUntil(context, "/approver_index", (r) => false);});
    }
    }

    
  // var thanan = ThananServices();
  //await thanan.addEvent(event);
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

}
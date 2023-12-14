import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enavit/models/og_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ThananServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //SecureStorage secureStorage = SecureStorage();

  Future<String> addEvent(Event newEvent) async {
    final docref =
        firestore.collection("Events").doc(newEvent.eventId.toString());

    Map<String, dynamic> obj = {
      "clubId": newEvent.clubId,
      "comments": newEvent.comments,
      "dateTime": newEvent.dateTime,
      "description": newEvent.description,
      "eventId": newEvent.eventId,
      "eventName": newEvent.eventName,
      "fee": newEvent.fee,
      "likes": newEvent.likes,
      "eventImageURL": newEvent.eventImageURL,
      "location": newEvent.location,
      "organisers": newEvent.organisers,
      "participants": newEvent.participants
    };

    await docref.set(obj);
    return "okey"; //push the object
  }

  Future<String> addImage(String imageName, XFile file) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("images");
    Reference referenceImageToUpload = referenceDirImages.child(imageName);
    var imageURL = "";
    try {
      referenceImageToUpload.putFile(File(file!.path));
      imageURL = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      print(error);
    }
    return imageURL;
  }
}

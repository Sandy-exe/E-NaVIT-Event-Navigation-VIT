import 'dart:convert';
import 'dart:io';
import 'package:enavit_main/models/og_models.dart';
import 'package:enavit_main/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:enavit_main/Data/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({super.key});

  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  final TextEditingController _clubBioTEC = TextEditingController();
  final TextEditingController _clubNameTEC = TextEditingController();
  final TextEditingController _clubEmailTEC = TextEditingController();
  // late String _eventClubTEC;

  // File? _image;
  // final picker = ImagePicker();
  // String? downloadUrl;
  // final imageNotifier = ValueNotifier<File?>(null);
  bool _isLoading = false; // Loading state variable

  // Future<void> _pickImage() async {
  //   try {
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //         imageNotifier.value = _image;
  //       });
  //     } else {
  //       _showSnackBar("No Image Selected");
  //     }
  //   } catch (e) {
  //     _showSnackBar("Error picking image");
  //   }
  // }

  // Future<void> _uploadImage() async {
  //   try {
  //     SecureStorage secureStorage = SecureStorage();
  //     String userData =
  //         await secureStorage.reader(key: "currentUserData") ?? "null";
  //     if (userData == "null") return;

  //     Map<String, dynamic> currentUserData = jsonDecode(userData);
  //     String clubId = currentUserData["clubs"][0];
  //     String userId = currentUserData["userid"];
  //     String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child("$clubId/images")
  //         .child("$uniqueFileName.userID$userId");
  //     UploadTask uploadTask = ref.putFile(_image!);
  //     await uploadTask.whenComplete(() async {
  //       downloadUrl = await ref.getDownloadURL();
  //       _eventImageURL.text = downloadUrl!;
  //     });

  //     _eventClubTEC = clubId;
  //   } catch (e) {
  //     _showSnackBar("Error uploading image");
  //   }
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  Future<void> _createClub() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      // await _uploadImage();
      Services services = Services();

      await services.addClub(Club(
          clubId: _clubNameTEC.text.split(' ').join('_'),
          clubName: _clubNameTEC.text,
          bio: _clubBioTEC.text,
          email: _clubEmailTEC.text,
          events: [],
          approvers: [],
          followers: [],
          posts: [],
          revenue: "0",
          expense: "0"));

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Upload Status'),
              content: Text('Club created successfully'),
            );
          },
        );

        Future.delayed(const Duration(seconds: 2), () async {
          String route = "/dean_index";
          Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
        });
      }
    } catch (e) {
      _showSnackBar("Error creating club");
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Creation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Create Club",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 80),
              _buildTextField(
                  _clubNameTEC, Icons.groups, 'Club name', 'Enter club name'),
              const SizedBox(height: 16),
              _buildTextField(_clubEmailTEC, Icons.email,
                  'Club Email', 'Enter club email id'),
              const SizedBox(height: 16),
              _buildTextField(_clubBioTEC, Icons.info,
                  'Club Bio', 'Enter club bio'),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(100))),
              //   onPressed: _pickImage,
              //   child: const Text('Upload Image',
              //       style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white)),
              // ),
              // const SizedBox(height: 16),
              // _image != null
              //     ? Image.file(
              //         _image!,
              //         width: 100,
              //         height: 100,
              //       )
              //     : const SizedBox.shrink(),
              // const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
                onPressed: _isLoading ? null : _createClub,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Club',
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

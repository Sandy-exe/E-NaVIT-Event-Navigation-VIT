import 'dart:convert';
import 'dart:io';

import 'package:enavit_main/Data/secure_storage.dart';
import 'package:enavit_main/services/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AProfileUpdatePage extends StatefulWidget {
  const AProfileUpdatePage({super.key});

  @override
  State<AProfileUpdatePage> createState() => _AProfileUpdatePageState();
}

class _AProfileUpdatePageState extends State<AProfileUpdatePage> {
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _mobileTEC = TextEditingController();
  final TextEditingController _profileImageURL = TextEditingController();

  late bool isLoggedIn;
  late Map<String, dynamic> currentUserData;

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

    if (userData == "null") return;
    Map<String, dynamic> currentUserData = jsonDecode(userData);
    String userId = currentUserData["userid"];

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("$userId/images")
        .child("$uniqueFileName.userID$userId");
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() async {
      downloadUrl = await ref.getDownloadURL();
      _profileImageURL.text = downloadUrl!;
    });
    // var imageURL = "";
  }

  showSnackBar(String message, Duration d) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: d.inSeconds),
    ));
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();

    isLoggedIn = await secureStorage.reader(key: 'isLoggedIn') == 'true';

    if (isLoggedIn) {
      String? currentUserDataString =
          await secureStorage.reader(key: "currentUserData");
      if (currentUserDataString != null) {
        currentUserData = jsonDecode(currentUserDataString);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initPrefs(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          } else {
            return Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  backgroundColor: Colors.grey[300],
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Center(child: Text('Edit Profile')),
                ),
                body: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                          currentUserData['profileImageURL'] ==
                                                      "null" &&
                                                  _image == null
                                              ? Image.asset(
                                                  'lib/images/VIT_LOGO.png')
                                              : _buildImage(context, _image)),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 10,
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        ImagePickerMethod();
                                      },
                                      child: const Icon(
                                        FontAwesomeIcons.camera,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Form(
                                child: Column(
                              children: [
                                TextFormField(
                                  controller: _name,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.user),
                                    labelText: currentUserData['name'],
                                    hintText: "Enter new name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailTEC,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.envelope),
                                    labelText: currentUserData['email'],
                                    hintText: "Enter new email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _mobileTEC,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.phone),
                                    labelText: currentUserData['phone_no'],
                                    hintText: "Enter new phone number",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    onPressed: () {
                                      updateprof();
                                    },
                                    child: const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ))));
          }
        });
  }

  Widget _buildImage(BuildContext context, [File? image]) {
    if (image != null) {
      return Image.file(image, fit: BoxFit.cover);
    } else {
      return currentUserData['profileImageURL'] == null
          ? Image.asset('lib/images/VIT_LOGO.png')
          : Image.network(currentUserData['profileImageURL'],
              fit: BoxFit.cover);
    }
  }

  void updateprof() async {
    await uploadImage();

    final String email =
        _emailTEC.text.isEmpty ? currentUserData['email'] : _emailTEC.text;
    final String phoneno =
        _mobileTEC.text.isEmpty ? currentUserData['phone_no'] : _mobileTEC.text;
    final String name =
        _name.text.isEmpty ? currentUserData['name'] : _name.text;

    final String profileImageURL = _profileImageURL.text.isEmpty
        ? _profileImageURL.text
        : _profileImageURL.text;

    Map<String, dynamic> newinfo = {
      "email": email,
      "phone_no": phoneno,
      "name": name,
      "profileImageURL": profileImageURL
    };

    currentUserData['email'] = email;
    currentUserData['phone_no'] = phoneno;
    currentUserData['name'] = name;
    currentUserData['profileImageURL'] = profileImageURL;
    SecureStorage secureStorage = SecureStorage();
    String newUserDataString = jsonEncode(currentUserData);
    await secureStorage.writer(
        key: "currentUserData", value: newUserDataString);

    Services services = Services();
    services.updateUser(currentUserData['userid'], newinfo);

    if (context.mounted)
      Navigator.pushNamedAndRemoveUntil(
          context, '/approver_index', (route) => false);

    ValueListenableBuilder<File?>(
      valueListenable: imageNotifier,
      builder: (context, value, child) {
        return _buildImage(context, value);
      },
    );
  }
}

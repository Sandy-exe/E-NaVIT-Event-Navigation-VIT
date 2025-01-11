import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/services/services.dart';

class EditMyClub extends StatefulWidget {
  final Club club;
  const EditMyClub({Key? key, required this.club}) : super(key: key);

  @override
  _EditMyClubState createState() => _EditMyClubState();
}

class _EditMyClubState extends State<EditMyClub> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController clubNameController;
  late TextEditingController bioController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    clubNameController = TextEditingController(text: widget.club.clubName);
    bioController = TextEditingController(text: widget.club.bio);
    emailController = TextEditingController(text: widget.club.email);
  }

  Future<void> saveClubDetails() async {
    if (_formKey.currentState!.validate()) {
      Services service = Services();
      Club updatedClub = Club(
        approvers: widget.club.approvers,
        clubName: clubNameController.text,
        clubId: widget.club.clubId,
        bio: bioController.text,
        email: emailController.text,
        events: widget.club.events,
        followers: widget.club.followers,
        posts: widget.club.posts,
        revenue: widget.club.revenue,
        expense: widget.club.expense,
      );
      await service.updateClubDetails(updatedClub);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    clubNameController.dispose();
    bioController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit My Club'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: clubNameController,
                decoration: const InputDecoration(labelText: 'Club Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the club name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border:
                      OutlineInputBorder(), // Optional: adds a border around the TextFormField
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bio';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline, // Allows multiline input
                maxLines: null, // Allows the TextFormField to expand as needed
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveClubDetails,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

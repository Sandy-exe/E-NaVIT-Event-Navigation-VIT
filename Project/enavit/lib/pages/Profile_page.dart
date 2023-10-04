import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/add_Event.dart';
import '../components/UserEvent_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Consumer<AddEvent>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          const Text(
            'My Events',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Expanded (
            child: ListView.builder(
              itemBuilder: (context,index) {
                //get event
                Event indi_event = value.getUserEventList()[index];
                return UserEventitem(event: indi_event,);
          } 
          ),
          ),
        ],
      )
    ); 
  }
}
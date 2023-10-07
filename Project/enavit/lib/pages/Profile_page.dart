import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/add_Event.dart';
import '../components/user_event_item.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEvent>(
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

                Expanded(
                  child: ListView.builder(
                      itemCount: value.getUserEventList().length,
                      itemBuilder: (context, index) {
                        //get event
                        print(value.getUserEventList().length);
                        Event indiEvent = value.getUserEventList()[index];
                        return UserEventitem(
                          event: indiEvent,
                        );
                      }),
                ),
              ],
            ));
  }
}


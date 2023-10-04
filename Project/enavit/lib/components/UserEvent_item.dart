import 'package:flutter/material.dart';
import 'package:enavit/models/event.dart';
import 'package:provider/provider.dart';
import '../models/add_Event.dart';

class UserEventitem extends StatefulWidget {
  Event event;
  const UserEventitem({super.key,required this.event});

  @override
  State<UserEventitem> createState() => _UserEventitemState();
}

class _UserEventitemState extends State<UserEventitem> {

  void removeEventFromUser() {
    Provider.of<AddEvent>(context, listen: false).removeEventFromUser(widget.event);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Image.asset(widget.event.imagePath),
        title: Text(widget.event.name),
        subtitle: Text(widget.event.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            //delete event
            setState(() {
              widget.event.remove();
            });
          },
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../pages/about_event_page.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final void Function()? onTap;
  const EventTile({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(event.id);
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AboutEvent(event: event,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        width: 213,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(event.imagePath),
    
            ),
    
            //Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                event.description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
    
            //fee+details
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //event name
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
    
                      //event fee
                      Text(
                        '\$' + event.fee,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';
import '../pages/main_pages/general_pages/about_event_page.dart';

class EventTile extends StatefulWidget {
  final Event event;
  const EventTile({super.key, required this.event});

  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  
 
  bool isFavorited = false;//random

  void toggleFavorite() async {
    print("Toggling Favorite");
    Services services = Services();
    bool newFavoriteStatus = await services.toggleFavEvents(widget.event.eventId);
    setState(() {
      isFavorited = newFavoriteStatus;
    });
    print('Favorite Toggled');
  }

  void share(Event event) {
    // function to share event
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutEvent(
              event: widget.event,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Event Image
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 5, bottom: 5),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                      width: 250.0, // desired width
                      child: widget.event.eventImageURL == "null"
                          ? Image.asset('lib/images/Vit_poster.jpg')
                          : Image.network(
                              widget.event.eventImageURL,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: toggleFavorite,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                child: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: const Color.fromARGB(255, 90, 88, 88),
                                  size: 30.0,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => share(widget.event),
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                child: const Icon(
                                  Icons.send_outlined,
                                  color: Color.fromARGB(255, 90, 88, 88),
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              // color: Colors.red,
              height: 400,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                          image: AssetImage('lib/images/VIT_LOGO.png')),
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

import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/pages/main_pages/general_pages/about_event_page.dart';
import 'package:intl/intl.dart';

class EventTile extends StatefulWidget {
  final Event event;
  const EventTile({super.key, required this.event});

  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    Services services = Services();

    bool favoriteStatus = await services.checkFavEvents(widget.event.eventId);
    setState(() {
      isFavorited = favoriteStatus;
      likecounts = widget.event.likes;
    });
  }

  int likecounts = 0; //random

  bool isFavorited = false; //random

  void toggleFavorite() async {
    Services services = Services();
    bool newFavoriteStatus =
        await services.toggleFavEvents(widget.event.eventId);
    setState(() {
      isFavorited = newFavoriteStatus;
      likecounts = isFavorited ? likecounts + 1 : likecounts - 1;
    });
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 300, // Adjust as needed for desired image height
                    child: widget.event.eventImageURL == "null"
                        ? Image.asset(
                            'lib/images/Vit_poster.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.event.eventImageURL,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.eventName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text(widget.event.location),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                widget.event.dateTime['startTime'].toString())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10, // Position it just above the event details
              right: 20,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: const Color.fromARGB(255, 90, 88, 88),
                            size: 30.0,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            likecounts.toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 88, 88),
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top:
                  270, // Adjust this to place it between the image and event details
              child: SizedBox(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Set the border color here
                        width: 2.0, // Set the border width here
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Image(
                      image: AssetImage('lib/images/VIT_LOGO.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

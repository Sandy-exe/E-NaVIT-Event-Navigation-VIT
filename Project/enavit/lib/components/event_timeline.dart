import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/compute.dart';
import 'package:enavit/models/og_models.dart';
import 'package:enavit/pages/main_pages/general_pages/about_event_page.dart';
import 'package:enavit/services/services.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class EventTimeline extends StatefulWidget {
  const EventTimeline({super.key});

  @override
  State<EventTimeline> createState() => _EventTimelineState();
}

class _EventTimelineState extends State<EventTimeline> {
  @override
  void initState() {
    super.initState();
  }

  
  List<Map<String, dynamic>> events = [];
  List<Event> eventList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<Compute>(builder: (context, value, child) {
      if (value.eventExist == 0) {
        return         const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  "No Events",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: value.timeLineEvents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return _buildEvent(value.timeLineEvents[index],context);
                },
              ),
            ),
          ],
        ),
      );
    }
    );
  }
}

Widget _buildEvent(Map<String, dynamic> event, BuildContext context) {
  return GestureDetector(
    onTap: () {
      print(event);
      Services  service = Services();

      service.getEventDetails(event['eventId']).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutEvent(event: value),
          ),
        );
      });
      // Navigator.push(
      // context,
      // MaterialPageRoute(builder: (context) => AboutEvent(event: event)
      // );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildTimeline(event['isLast']),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['toDisplay']),
                const SizedBox(
                  width: 10,
                ),
                _buildCard(event),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCard(Map<String, dynamic> event) {
  if (event["name"] == "") {
      return Container();
  }
  return Container(
    width: 260,
    height: 120,
    decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          event['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              event['startTime'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              event['endTime'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTimeline(String isLast) {
  return SizedBox(
    height: 100,
    width: 20,
    child: TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0,
      isFirst: true,
      isLast: isLast == "true" ? true : false,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0,
        width: 20,
        color: Colors.black,
        indicator: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 202, 198, 198),
                width: 5,
              )),
        ),
      ),
      beforeLineStyle: const LineStyle(
        color: Colors.black,
        thickness: 2,
      ),
    ),
  );
}

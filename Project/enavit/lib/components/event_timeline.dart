import 'dart:convert';

import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/components/compute.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    getEventsUserByDate();
  }

  SecureStorage secureStorage = SecureStorage();
  List<Map<String, dynamic>> events = [];
  Future<void> getEventsUserByDate() async {
    String? eventsString = await secureStorage.reader(key: "events");
    List<String> userEvent =
        eventsString != null ? eventsString.split("JOIN") : [];
    for (final event in userEvent) {
      Map<String, dynamic> eventData = jsonDecode(event);
      Map<String, dynamic> tempData = {"name": eventData["eventName"] , "time":eventData["dateTime"]["startTime"].substring(11,16),"color":"red"};
      events.add(tempData);
    }
    events.sort((a, b) => a['time'].compareTo(b['time']));
    print(events);
  }
    var dropdown = ["Month", "Week", "Upcoming", "Past", "Year"];
  String dropdownValue = 'Month';
    @override
    Widget build(BuildContext context) {
      return Consumer<Compute>(
          builder: (context, value, child) => Expanded(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Event Timeline',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.black,
                                  value: dropdownValue,
                                  iconEnabledColor: Colors.white,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 30,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  items: dropdown.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Center(child: Text(items)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: events.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return _buildEvent(events[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ));
    }
  }

  Widget _buildEvent(Map<String, dynamic> event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildTimeline(),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['time']),
                const SizedBox(
                  width: 10,
                ),
                _buildCard(event),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> event) {
    return Container(
      width: 250,
      height: 80,
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
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
          Text(
            event['time'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return SizedBox(
      height: 100,
      width: 20,
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0,
        isFirst: true,
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

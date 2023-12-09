import 'package:enavit/components/compute.dart';
import 'package:flutter/material.dart';
import 'package:enavit/components/date_picker.dart';
import 'package:enavit/components/event_timeline.dart';
import 'package:provider/provider.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  var dropdown = ["Week","Month","Year","Upcoming","Past"];
  String dropdownValue = 'Week';

  Future<void> updateFilter(String dropdownValue) async {
    if (dropdownValue == 'Week'){
      Provider.of<Compute>(context, listen: false).datePickerWeek(3);
    } else if (dropdownValue == 'Month'){
      Provider.of<Compute>(context, listen: false).datePickerMonth(6);}
    // } else if (dropdownValue == 'Year'){
    //   Provider.of<Compute>(context, listen: false).datePickerYear(1);
    // } else if (dropdownValue == 'Upcoming'){
    //   Provider.of<Compute>(context, listen: false).datePickerUpcoming();
    // } else if (dropdownValue == 'Past'){
    //   Provider.of<Compute>(context, listen: false).datePickerPast();
    // }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 100,
                child: DatePicker()),
              const SizedBox(
                height: 20,
              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                updateFilter(dropdownValue);
                                
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
              const EventTimeline(),
            ],
          ),
        ),
      ),
    );
  }
}

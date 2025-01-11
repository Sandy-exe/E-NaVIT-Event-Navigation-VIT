import 'package:flutter/material.dart';
import 'package:enavit/components/compute.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  void initState() {
    super.initState();
  }

  // Future<void> initPrefs() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_){
  //     Provider.of<Compute>(context, listen: false).datePickerWeek(3);
  //   });
  // }

  Future<void> ontimelinechange(int index) async {
    if (Provider.of<Compute>(context, listen: false).updateFilter == "Week") {
      Provider.of<Compute>(context, listen: false).datePickerWeek(index);
    } else if (Provider.of<Compute>(context, listen: false).updateFilter ==
        "Month") {
      Provider.of<Compute>(context, listen: false).datePickerMonth(index);
    } else if (Provider.of<Compute>(context, listen: false).updateFilter ==
        "Year") {
      Provider.of<Compute>(context, listen: false).datePickerYear(index);
    } else if (Provider.of<Compute>(context, listen: false).updateFilter ==
        "History") {
      Provider.of<Compute>(context, listen: false).datePickerHistory(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ontimelinechange(3),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.grey[300],
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          } else {
            return Consumer<Compute>(
              builder: (context, value, child) => Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () => ontimelinechange(index),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: value.selected == index
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  value.datePickerUpper[index],
                                  style: TextStyle(
                                    color: value.selected == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: value.selected == index
                                        ? Colors.white
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      value.datePickerLower[index],
                                      style: TextStyle(
                                        color: value.selected == index
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    separatorBuilder: (_, index) => const SizedBox(
                          width: 5,
                        ),
                    itemCount: value.datePickerLower.length),
              ),
            );
          }
        });
  }
}

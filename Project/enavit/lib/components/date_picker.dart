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
    print("ok");
  }

  Future<void> initPrefs() async {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<Compute>(context, listen: false).datePicker(3);
    });
  }

  void ontimelinechange(int index) {
      Provider.of<Compute>(context, listen: false).datePicker(index);
  }

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initPrefs(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center( 
              child: CircularProgressIndicator(),
            ));
          } else {
            return Consumer<Compute>(
      builder: (context,value, child) => Container(
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
                      color: value.selected == index ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          value.weekList[index],
                          style: TextStyle(
                            color:
                                value.selected == index ? Colors.white : Colors.black,
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
                            color:
                                value.selected == index ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              value.dayList[index],
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
            itemCount: value.weekList.length),
      ),
    );
          }
        });
  }
}

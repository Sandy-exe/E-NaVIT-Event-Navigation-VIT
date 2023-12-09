import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';
import '../pages/main_pages/general_pages/about_event_page.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final void Function()? onTap;
  const EventTile({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutEvent(
              event: event,
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
                padding: const EdgeInsets.only(left: 4.0 , top:5, bottom:5),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        width: 250.0, // desired width
                        child: Image.asset('lib/images/GOJO.jpg'),
                      ),
                    ),
                    const SizedBox(height: 10,),


                    SizedBox(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                              onTap: onTap,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                child: const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Color.fromARGB(255, 90, 88, 88),
                                  size: 30.0,
                                ),
                              ),
                                                      ),
                                                      GestureDetector(
                              onTap: onTap,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                child: const Icon(
                                  Icons.comment_outlined,
                                  color: Color.fromARGB(255, 90, 88, 88),
                                  size: 30.0,
                                ),
                              ),
                                                      ),
                                                      GestureDetector(
                              onTap: onTap,
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
                          GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              child: const Icon(
                                Icons.bookmark_border_outlined,
                                color: Color.fromARGB(255, 90, 88, 88),
                                size: 30.0,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

            //Description, event name, event fee, and plus button
            // Expanded(
              
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.grey[100],
            //       borderRadius: BorderRadius.circular(12.0),
            //     ),
            //     padding: const EdgeInsets.all(4.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         //Event Name
            //         // Padding(
            //         //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            //         //   child: Text(
            //         //     event.name,
            //         //     style: const TextStyle(
            //         //       fontsize: 30.0,
            //         //       fontWeight: FontWeight.bold,
            //         //     ),
            //         //   ),
            //         // ),

            //         // //Event Description
            //         // Padding(
            //         //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            //         //   child: Text(
            //         //     event.description,
            //         //     style: const TextStyle(
            //         //       fontSize: 16.0,
            //         //     ),
            //         //   ),
            //         // ),

            //         // //Event Fee
            //         // Padding(
            //         //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            //         //   child: Text(
            //         //     event.fee,
            //         //     style: const TextStyle(
            //         //       fontSize: 16.0,
            //         //     ),
            //         //   ),
            //         // ),

            //         //Plus Button
            //       ],
            //     ),
            //   ),
            // ),

            SizedBox(
              // color: Colors.red,
              height: 400,
              width:80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                          image: AssetImage('lib/images/Pochita.jpg')),
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

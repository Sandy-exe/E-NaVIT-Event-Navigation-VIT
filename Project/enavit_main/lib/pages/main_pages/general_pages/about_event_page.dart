import 'dart:convert';

import 'package:enavit_main/components/send_event_announcement.dart';
import 'package:enavit_main/components/view_event_announcement.dart';
import 'package:enavit_main/dashboard/dashboard_screen.dart';
import 'package:enavit_main/pages/main_pages/attendance/give_attendance.dart';
// import 'package:enavit_main/pages/main_pages/attendance/give_attendance.dart';
import 'package:enavit_main/pages/main_pages/attendance/take_attendance.dart';
import 'package:enavit_main/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:enavit_main/models/og_models.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:enavit_main/Data/secure_storage.dart';
import 'package:enavit_main/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../../models/add_event.dart';
//import 'package:provider/provider.dart';

class AboutEvent extends StatefulWidget {
  final Event event;
  const AboutEvent({super.key, required this.event});
  @override
  State<AboutEvent> createState() => _AboutEventState();
}

class _AboutEventState extends State<AboutEvent> {
  late Razorpay razorpay;
  late bool isLoggedIn;
  late Map<String, dynamic> currentUserData;
  late bool isOrganized = false;
  late bool ifRegistered = false;

  void razorPayDialogBox(String content) {
    //Provider.of<AddEvent>(context, listen: false).addEventToUser(event);
    // get a Event from Event list
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Status"),
        content: Text(content),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() async {
    SecureStorage secureStorage = SecureStorage();
    isLoggedIn = await secureStorage.reader(key: 'isLoggedIn') == 'true';

    if (isLoggedIn) {
      String? currentUserDataString =
          await secureStorage.reader(key: "currentUserData");
      if (currentUserDataString != null) {
        currentUserData = jsonDecode(currentUserDataString);
      }
    }

    var options = {
      'key': 'rzp_test_nToF04vc477NSJ',
      'amount': num.parse(widget.event.fee) *
          100.00, //in the smallest currency sub-unit.
      'name': 'ENAVIT',
      'description': "Payment for ${widget.event.eventName}",
      'timeout': 60, // in seconds
      'prefill': {
        'contact': currentUserData['phone_no'],
        'email': currentUserData['email']
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    razorPayDialogBox("Payment Successfull");
    updateUserAndEventDetails(currentUserData['userid'], widget.event.eventId);

    DateTime now = DateTime.now();
    debugPrint('Now: $now');
    DateTime inputDateTime = widget.event.dateTime['startTime'];
    debugPrint('Input: $inputDateTime');

    // Calculate the seconds for each notification
    int twoHoursBefore = inputDateTime.difference(now).inSeconds - 2 * 60 * 60;
    int oneHourBefore = inputDateTime.difference(now).inSeconds - 1 * 60 * 60;
    int tenMinutesBefore = inputDateTime.difference(now).inSeconds - 10 * 60;
    int eventStarts = inputDateTime.difference(now).inSeconds;

    String eventName = widget.event.eventName;
    // Schedule the notifications
    await NotificationService.showNotification(
      title: 'Event Reminder',
      body: 'Event will start in 2 hours',
      scheduled: true,
      interval: twoHoursBefore,
    );
    await NotificationService.showNotification(
      title: 'Event Reminder',
      body: '$eventName Event will start in 1 hour',
      scheduled: true,
      interval: oneHourBefore,
    );
    await NotificationService.showNotification(
      title: 'Event Reminder',
      body: 'Event will start in 10 minutes',
      scheduled: true,
      interval: tenMinutesBefore,
    );
    await NotificationService.showNotification(
      title: 'Event Reminder',
      body: 'Event is starting now',
      scheduled: true,
      interval: eventStarts,
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    razorPayDialogBox("Payment Failed");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    razorPayDialogBox("External Wallet Selected");
  }

  Future<void> initPrefs() async {
    SecureStorage secureStorage = SecureStorage();

    isLoggedIn = await secureStorage.reader(key: 'isLoggedIn') == 'true';

    String? currentUserDataString =
        await secureStorage.reader(key: "currentUserData");
    if (currentUserDataString != null) {
      currentUserData = jsonDecode(currentUserDataString);
    }

    Services service = Services();
    List<Event> events = await service.getOrganizedEventsView(context, " ");

    for (Event event in events) {
      if (event.eventId == widget.event.eventId) {
        isOrganized = true;
      }
    }

    String eventString = await secureStorage.reader(key: "events") ?? "null";

    if (eventString == '' || eventString == 'null') {
      return;
    }

    List<String> userEvent = eventString.split("JOIN");

    for (String event in userEvent) {
      Map<String, dynamic> eventDetail = jsonDecode(event);
      if (eventDetail['eventId'] == widget.event.eventId) {
        ifRegistered = true;
      }
    }

    print(isOrganized);
    print(ifRegistered);
    // print(userEvent);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Center(
              child: Text(
                  'An error occurred!')); // Show error message if any error occurs
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.6,
                elevation: 0,
                snap: true,
                floating: true,
                stretch: true,
                backgroundColor: Colors.grey.shade50,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                  ],
                  background: widget.event.eventImageURL == "null"
                      ? Image.asset(
                          'lib/images/Vit_poster.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.event.eventImageURL,
                          fit: BoxFit.cover,
                        ),
                ),
                actions: <Widget>[
                  if (ifRegistered || isOrganized)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PopupMenuButton<int>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 20,
                        ),
                        itemBuilder: (context) => [
                          // if (isOrganized)
                          // const PopupMenuItem(
                          //   value: 1,
                          //   child: Text("Edit Event Profile"),
                          // ),
                          if (isOrganized)
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Delete Event"),
                            ),
                          if (isOrganized)
                            const PopupMenuItem(
                              value: 3,
                              child: Text("View Announcements"),
                            ),
                          if (isOrganized)
                            const PopupMenuItem(
                              value: 4,
                              child: Text("Mark Attendance"),
                            ),
                          if (ifRegistered)
                            const PopupMenuItem(
                              value: 5,
                              child: Text("Submit Attendance"),
                            ),
                        ],
                        onSelected: (value) async {
                          if (value == 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventAnnouncement(
                                          event: widget.event,
                                        )));
                            //edit event
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EditEventDetails()));
                          } else if (value == 2) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController _controller =
                                    TextEditingController();
                                bool _isDeleteEnabled = false;

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text("Delete Event"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                              "Are you sure you want to delete this event?"),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: _controller,
                                            onChanged: (text) {
                                              setState(() {
                                                _isDeleteEnabled =
                                                    text.toLowerCase() ==
                                                        "delete";
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Type 'delete' to confirm",
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: _isDeleteEnabled
                                              ? () {
                                                  Services service = Services();
                                                  service.deleteEvents(
                                                      widget.event.eventId);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                }
                                              : null, // Disable the button if "delete" is not typed
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          } else if (value == 1) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EditEventDetails()));
                          } else if (value == 4) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TakeAttendance(
                                          // qrData: widget.event.eventId,
                                        )));
                          } else if (value == 5) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GiveAttendance()));
                          }
                        },
                      ),
                    )
                ],
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(45),
                    child: Transform.translate(
                      offset: const Offset(0, 1),
                      child: Container(
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                            child: Container(
                          width: 50,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                      ),
                    )),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Logo Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    widget.event.eventName,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "", // Placeholder for event brand
                                  style: TextStyle(
                                    color: Colors.orange.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Image(
                                image: AssetImage('lib/images/VIT_LOGO.png'),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          "About",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height:
                                10), // Adds some space between "About" and description
                        Text(
                          widget.event.description,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.grey.shade800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Event Location
                        Text(
                          "Location: ${widget.event.location}",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Event Fee
                        Text(
                          "Fee: ${widget.event.fee}",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Start Date & Time
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text(
                              "Start: ${DateFormat('yyyy-MM-dd kk:mm').format(widget.event.dateTime['startTime'])}",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // End Date & Time
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text(
                              "End: ${DateFormat('yyyy-MM-dd kk:mm').format(widget.event.dateTime['endTime'])}",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Payment or Dashboard Button
                        MaterialButton(
                          onPressed: () {
                            if (isOrganized) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                          event: widget.event)));
                            } else if (ifRegistered) {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: Text("Registration Status"),
                                  content: Text("You Already Registered"),
                                ),
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                              });
                            } else {
                              openCheckout();
                            }
                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.yellow[800],
                          child: Center(
                            child: Text(
                              isOrganized
                                  ? "View Dashboard"
                                  : ifRegistered
                                      ? "Already Registered"
                                      : "Go to Payment",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Send/View Announcement Button
                        isOrganized
                            ? MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SEVENTAnnouncement(
                                                event: widget.event,
                                                userId:
                                                    currentUserData['userid'],
                                                userName:
                                                    currentUserData['name'],
                                              )));
                                },
                                height: 50,
                                elevation: 0,
                                splashColor: Colors.yellow[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.yellow[800],
                                child: const Center(
                                  child: Text(
                                    "Send Announcement",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            : ifRegistered
                                ? MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EventAnnouncement(
                                                    event: widget.event,
                                                  )));
                                    },
                                    height: 50,
                                    elevation: 0,
                                    splashColor: Colors.yellow[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.yellow[800],
                                    child: const Center(
                                      child: Text(
                                        "View Announcements",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  )
                                : Container(),
                        const SizedBox(height: 20),
                      ],
                    ))
              ])),
            ]),
          );
        }
      },
    );
  }
}

void updateUserAndEventDetails(String userId, String eventId) {
  Services service = Services();

  Map<String, dynamic> userDetails = {
    "events": FieldValue.arrayUnion([eventId]),
  };

  service.updateEvent(eventId, {"userId": userId});
  service.updateUser(userId, userDetails);
}

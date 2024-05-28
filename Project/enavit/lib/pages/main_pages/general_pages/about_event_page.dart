import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:enavit/dashboard/dashboard_screen.dart';
import 'package:enavit/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:enavit/models/og_models.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:enavit/Data/secure_storage.dart';
import 'package:enavit/services/services.dart';
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
  }

  @override
  void initState() {
    super.initState();

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
    Services service = Services();
    List<Event> events = await service.getOrganizedEventsView(context);

    for (Event event in events) {
      if (event.eventId == widget.event.eventId) {
        isOrganized = true;
      }
    }
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
                  isOrganized
                      ? Container(
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
                              const PopupMenuItem(
                                value: 1,
                                child: Text("Edit Profile"),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text("View Stats"),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 1) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => EditEventDetails()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardScreen(
                                            event: widget.event)));
                              }
                            },
                          ),
                        )
                      : Container(),
                ],
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(45),
                    child: Transform.translate(
                      offset: const Offset(0, 1),
                      child: Container(
                        height: 45,
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
                    height: MediaQuery.of(context).size.height * 0.55,
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.88,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.event.eventName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: const Image(
                                              image: AssetImage(
                                                  'lib/images/VIT_LOGO.png')),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  // widget.product.brand,
                                  "",
                                  style: TextStyle(
                                    color: Colors.orange.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.event.description,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.grey.shade800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.event.location,
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Fee: ${widget.event.fee}",
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            openCheckout();
                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.yellow[800],
                          child: const Center(
                            child: Text(
                              "Go to Payment Page",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )
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

  Map<String, dynamic> eventDetails = {
    "participants": FieldValue.arrayUnion([userId]),
  };

  Map<String, dynamic> userDetails = {
    "events": FieldValue.arrayUnion([eventId]),
  };

  service.updateEvent(eventId, eventDetails);
  service.updateUser(userId, userDetails);
}

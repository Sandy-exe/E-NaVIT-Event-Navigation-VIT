import 'dart:convert';

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
  void dispose(){
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
      'amount': num.parse(widget.event.fee)*100.00, //in the smallest currency sub-unit.
      'name': 'ENAVIT', 
      'description': "Payment for ${widget.event.eventName}",
      'timeout': 60, // in seconds
      'prefill': {'contact': currentUserData['phone_no'], 'email': currentUserData['email']},
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    razorPayDialogBox("Payment Successfull");
    updateUserAndEventDetails(currentUserData['userid'], widget.event.eventId);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    razorPayDialogBox("Payment Failed");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    razorPayDialogBox("External Wallet Selected");
  }


  @override
  Widget build(BuildContext context) {
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
              background: Image.asset(
                // widget.product.imageURL,r
                "lib/images/Gojo.jpg",
                fit: BoxFit.cover,
              )),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          Text(
                            widget.event.eventName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
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
                        "",style: TextStyle(color: Colors.black, fontSize: 16),
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
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Fee: ${widget.event.fee}",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ))
        ])),
      ]),
    );
  }
}

void updateUserAndEventDetails(String userId, String eventId) {
  Services service = Services();

  Map<String,dynamic> eventDetails = {
    "participants": FieldValue.arrayUnion([userId]),
  };

  Map<String,dynamic> userDetails = {
    "events": FieldValue.arrayUnion([eventId]),
  };

  service.updateEvent(eventId, eventDetails);
  service.updateUser(userId, userDetails);

  

}
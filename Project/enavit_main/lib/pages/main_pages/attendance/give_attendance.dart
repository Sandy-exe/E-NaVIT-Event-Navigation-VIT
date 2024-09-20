import 'dart:developer';

import 'package:enavit_main/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'package:permission_handler/permission_handler.dart';

class GiveAttendance extends StatefulWidget {
  const GiveAttendance({super.key});

  @override
  _GiveAttendanceState createState() => _GiveAttendanceState();
}

class _GiveAttendanceState extends State<GiveAttendance> {
  String _nfcStatus = "Ready to send";
  String _stringToSend = "21BCE1999"; // Your string here
  bool isPermissionGranted = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkCameraPermission();
  // }

  Future<void> _sendNfcMessage() async {
    setState(() {
      _nfcStatus = "Sending...";
    });

    try {
      // Start NFC session
      NFCTag tag = await FlutterNfcKit.poll();

      // Check if it's an NDEF tag
      if (tag.ndefAvailable!) {
        await FlutterNfcKit.transceive([
          "02", // Start of NDEF message
          "00", // Length of NDEF message
          "03", // TNF (short record)
          "0D", // Payload length (this is an example, adjust for your string)
          _stringToSend // Send your message in hex or convert to a valid format
        ].join());

        setState(() {
          _nfcStatus = "Message sent!";
        });
      } else {
        setState(() {
          _nfcStatus = "NDEF not supported";
        });
      }

      await FlutterNfcKit.finish();
    } catch (e) {
      setState(() {
        _nfcStatus = "Failed: $e";
      });
    }
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (controller != null) {
  //     controller!.pauseCamera();
  //     controller!.resumeCamera();
  //   }
  // }

  // Future<void> _checkCameraPermission() async {
  //   var status = await Permission.camera.status;
  //   if (status.isDenied) {
  //     status = await Permission.camera.request();
  //   }

  //   if (status.isGranted) {
  //     setState(() {
  //       isPermissionGranted = true;
  //     });
  //   } else if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   } else {
  //     setState(() {
  //       isPermissionGranted = false;
  //     });
  //   }
  // }

  // Future<void> _stopCamera() async {
  //   await controller?.pauseCamera();
  //   controller?.dispose();
  // }

  // Future<void> _showCheckingAttendanceMessage(String? scannedData) async {
  //   // Show loading dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => const AlertDialog(
  //       title: Text('Checking Attendance'),
  //       content: Row(
  //         children: [
  //           CircularProgressIndicator(),
  //           SizedBox(width: 20),
  //           Text('Please wait...'),
  //         ],
  //       ),
  //     ),
  //   );

  //   // Simulate checking attendance
  //   Services service = Services();
  //   String response = await service.checkAttendance(scannedData!);

  //   print('Attendance check response: $response');

  //   // Dismiss loading dialog
  //   Navigator.of(context).pop();

  //   // Show result message
  //   if (response == 'success') {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Attendance checked successfully!')),
  //     );
  //   } else if (response == 'Not a participant') {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('Not a Participant of the correct Event!')),
  //     );
  //   } else if (response == 'Already attended') {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Attendance already checked!')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to check attendance!')),
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // if (!isPermissionGranted) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('NFC Scanner'),
    //     ),
    //     body: const Center(
    //       child:
    //           Text('Camera permission denied. Please enable it in settings.'),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Tag Scanner'),
      ),
      body: Column(
        children: [
          Text(_nfcStatus),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendNfcMessage,
            child: Text('Send via NFC'),
          ),
        ],
      ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });

  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //     _handleScan(scanData);
  //   });
  // }

  // void _handleScan(Barcode scanData) {
  //   print('Scanned QR Code Data: ${scanData.code}');
  //   _stopCamera();
  //   _showCheckingAttendanceMessage(scanData.code);
  // }
}

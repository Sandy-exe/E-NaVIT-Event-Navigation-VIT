import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

// class TakeAttendance extends StatelessWidget {
//   final String qrData;
//   final String? embeddedImagePath;

//   const TakeAttendance({
//     super.key,
//     required this.qrData,
//     this.embeddedImagePath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code'),
//       ),
//       body: Center(
//         child: QrImageView(
//           data: qrData,
//           version: QrVersions.auto,
//           size: 320,
//           gapless: false,
//           embeddedImage:
//               embeddedImagePath != null ? AssetImage(embeddedImagePath!) : null,
//           embeddedImageStyle: embeddedImagePath != null
//               ? const QrEmbeddedImageStyle(
//                   size: Size(80, 80),
//                 )
//               : null,
//           errorStateBuilder: (context, error) {
//             return const Center(
//               child: Text(
//                 'Uh oh! Something went wrong...',
//                 textAlign: TextAlign.center,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class TakeAttendance extends StatefulWidget {
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  List<String> _receivedMessages = []; // List to store received NFC strings
  String _nfcStatus = "Ready to scan";

  Future<void> _startNfcScan() async {
    setState(() {
      _nfcStatus = "Scanning...";
    });

    try {
      // Poll NFC tag (this listens for an NFC tag to be detected)
      while (true) {
        NFCTag tag =
            await FlutterNfcKit.poll(); // Scans until a tag is detected

        if (tag.ndefAvailable!) {
          // Read NDEF data from the tag
          final ndefMessage = await FlutterNfcKit.readNDEFRecords();

          // Extract the payload (the message) from the NDEF record(s)
          for (var record in ndefMessage) {
            String message = String.fromCharCodes(record.payload as Iterable<int>);

            setState(() {
              _receivedMessages.add(message); // Add received message to list
              _nfcStatus = "Message received: $message";
            });
          }
        } else {
          setState(() {
            _nfcStatus = "NDEF not supported on this tag.";
          });
        }

        await FlutterNfcKit.finish(); // End the NFC session and start again
      }
    } catch (e) {
      setState(() {
        _nfcStatus = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Receiver'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_nfcStatus),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNfcScan,
              child: Text('Start NFC Scan'),
            ),
            SizedBox(height: 20),
            Text(
              'Received Messages:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _receivedMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_receivedMessages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

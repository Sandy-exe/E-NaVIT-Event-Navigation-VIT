import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class TakeAttendance extends StatefulWidget {
  // final String qrData;
  // final String? embeddedImagePath;

  const TakeAttendance({
    super.key,
    // required this.qrData,
    // this.embeddedImagePath,
  });

  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  // FlutterBluePlus flutterBlue = FlutterBluePlus;
  List<ScanResult> scannedDevices = [];

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scannedDevices = results;
      });
    });

    FlutterBluePlus.stopScan();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.read) {
          var attendanceToken = await characteristic.read();
          logAttendance(attendanceToken);
          await device.disconnect();
        }
      }
    }
  }

  void logAttendance(List<int> token) {
    String tokenString = String.fromCharCodes(token);
    print('Received attendance token: $tokenString');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Taking attendance')),
      body: ListView.builder(
        itemCount: scannedDevices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(scannedDevices[index].device.name),
            subtitle: Text(scannedDevices[index].device.id.toString()),
            onTap: () => connectToDevice(scannedDevices[index].device),
          );
        },
      ),
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code'),
//       ),
//       body: Center(
//         child: QrImageView(
//           data: widget.qrData,
//           version: QrVersions.auto,
//           size: 320,
//           gapless: false,
//           embeddedImage: widget.embeddedImagePath != null
//               ? AssetImage(widget.embeddedImagePath!)
//               : null,
//           embeddedImageStyle: widget.embeddedImagePath != null
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

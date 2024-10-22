import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// A widget to handle attendance sending from a student to a teacher via Bluetooth.
class GiveAttendance extends StatefulWidget {
  const GiveAttendance({super.key});

  @override
  _GiveAttendanceState createState() => _GiveAttendanceState();
}

class _GiveAttendanceState extends State<GiveAttendance> {
  /// The Bluetooth device representing the teacher's device.
  BluetoothDevice? teacherDevice;

  /// Unique ID for the student.
  final String studentId = '21BCE0666';

  /// Tracks whether the scanning for devices is ongoing.
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    requestPermissionsAndStartAdvertising();
  }

  /// Requests necessary Bluetooth permissions and starts advertising (scanning for the teacher's device).
  Future<void> requestPermissionsAndStartAdvertising() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      // If permissions are granted, start the scan
      startAdvertising();
    } else {
      // Handle the case when permissions are not granted
      print('Bluetooth permissions not granted');
    }
  }

  /// Starts scanning for the teacher's Bluetooth device.
  void startAdvertising() {
    setState(() {
      isScanning = true; // Set scanning state to true
    });

    // Start scanning for Bluetooth devices
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Listen for scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // Check if the scanned device is the teacher's device
        if (r.device.name == 'TeacherDevice') {
          setState(() {
            teacherDevice = r.device; // Store the teacher's device
          });
        }
      }
    }).onDone(() {
      // Set scanning state to false when done
      setState(() {
        isScanning = false;
      });
    });
  }

  /// Sends the student's attendance ID to the teacher's device.
  void sendAttendance() async {
    if (teacherDevice != null) {
      try {
        // Connect to the teacher's Bluetooth device
        await teacherDevice!.connect();
        List<BluetoothService> services =
            await teacherDevice!.discoverServices();

        // Iterate through the services and characteristics to find the writable characteristic
        for (BluetoothService service in services) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.properties.write) {
              // Write the student ID to the characteristic
              await characteristic.write(studentId.codeUnits);
              print('Attendance sent: $studentId');
              await teacherDevice!.disconnect(); // Disconnect after sending
              return; // Exit after sending attendance
            }
          }
        }
      } catch (e) {
        print('Error sending attendance: $e'); // Handle any errors that occur
      }
    } else {
      print('No teacher device found'); // Inform user if no device is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student - Attendance Sender')),
      body: Center(
        child: ElevatedButton(
          // Disable button while scanning
          onPressed: isScanning ? null : sendAttendance,
          child: isScanning
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                    const SizedBox(
                        width: 10), // Spacing between loader and text
                    const Text('Scanning...'), // Indicate scanning state
                  ],
                )
              : const Text('Send Attendance'), // Default button text
        ),
      ),
    );
  }
}

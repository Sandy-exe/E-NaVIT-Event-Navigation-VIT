import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class TakeAttendance extends StatefulWidget {
  const TakeAttendance({super.key});

  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  List<ScanResult> scannedDevices = [];
  late StreamSubscription<List<ScanResult>> subscription;
  bool isScanning = false; // Track scanning state

  @override
  void initState() {
    super.initState();
    requestPermissions(); // Request permissions at startup
  }

  Future<void> requestPermissions() async {
    print("Requesting permissions...");
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      // Permissions granted, start the scan
      print("Permissions granted, starting scan...");
      scanForDevices();
    } else {
      // Handle the case when permissions are not granted
      print('Permissions not granted');
    }
  }

  void scanForDevices() async {
    setState(() {
      scannedDevices.clear(); // Clear the list before scanning
      isScanning = true; // Update scanning state
    });

    // Wait for Bluetooth to be enabled
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    // Start scanning
    var scanResult = FlutterBluePlus.onScanResults.listen(
      (results) {
        try {
          if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');

            setState(() {
              // Update scanned devices with the new result
              scannedDevices.add(r);
            });
          }
        } catch (e) {
          print('Error updating scanned devices: $e'); // Handle any errors here
        }
      },
      onError: (e) => print(e),
    );

    // Cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(scanResult);

    // Start scanning with a timeout
    await FlutterBluePlus.startScan(
      timeout: Duration(seconds: 15),
    );

    // Wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    // Stop scanning
    await FlutterBluePlus.stopScan();

    setState(() {
      isScanning = false; // Update scanning state to false
    });

    print("Scanning stopped. Total scanned devices: ${scannedDevices.length}");
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
      appBar: AppBar(title: const Text('Taking Attendance')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: requestPermissions, // Just call requestPermissions
            child: isScanning
                ? const CircularProgressIndicator() // Show loading indicator while scanning
                : const Text('Scan for Devices'), // Default button text
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scannedDevices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scannedDevices[index].device.advName),
                  subtitle:
                      Text(scannedDevices[index].device.remoteId.toString()),
                  onTap: () => connectToDevice(scannedDevices[index].device),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

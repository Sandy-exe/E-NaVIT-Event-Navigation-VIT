import 'dart:developer';

import 'package:enavit_main/services/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class GiveAttendance extends StatefulWidget {
  const GiveAttendance({super.key});

  @override
  _GiveAttendanceState createState() => _GiveAttendanceState();
}

class _GiveAttendanceState extends State<GiveAttendance> {
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  // QRViewController? controller;
  // bool isPermissionGranted = false;
  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? teacherDevice;
  final String studentId = '21BCE0666'; // Unique ID for each student

  @override
  void initState() {
    super.initState();
    startAdvertising();
  }

  void startAdvertising() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'TeacherDevice') {
          setState(() {
            teacherDevice = r.device;
          });
        }
      }
    });
  }

  void sendAttendance() async {
    if (teacherDevice != null) {
      await teacherDevice!.connect();
      List<BluetoothService> services = await teacherDevice!.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.write) {
            await characteristic.write(studentId.codeUnits);
            await teacherDevice!.disconnect();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student - Attendance Sender')),
      body: Center(
        child: ElevatedButton(
          onPressed: sendAttendance,
          child: Text('Send Attendance'),
        ),
      ),
    );
  }
}


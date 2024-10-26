import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:permission_handler/permission_handler.dart';

class TakeAttendance extends StatefulWidget {
  const TakeAttendance({Key? key}) : super(key: key);

  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  late NearbyService nearbyService;
  List<NearbyDevice> studentDevices = [];
  String message = 'Welcome! Please start searching for student devices.';
  bool isSearching = false;
  Timer? searchTimer;
  int remainingTime = 20; // 20-second countdown

  @override
  void initState() {
    super.initState();
    requestPermissionsAndStartSearching();
  }

  Future<void> requestPermissionsAndStartSearching() async {
    if (await Permission.locationWhenInUse.request().isGranted &&
        await Permission.bluetooth.request().isGranted) {
      startSearching();
    } else {
      updateMessage(
          'Please enable location and Bluetooth permissions in settings.');
    }
  }

  void startSearching() async {
    nearbyService = NearbyService.getInstance();
    await nearbyService.initialize();

    nearbyService.android?.requestPermissions();
    final isWifiEnabled = await nearbyService.android?.checkWifiService();

    if (isWifiEnabled ?? false) {
      setState(() {
        isSearching = true;
        remainingTime = 20; // Reset the timer to 20 seconds
        message = 'Searching for student devices...';
      });

      // Start the 20-second countdown timer
      searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime--;
          if (remainingTime <= 0) {
            stopSearching();
          }
        });
      });

      // Start discovering nearby devices
      try {
        final result = await nearbyService.discover();
        if (result) {
          nearbyService.getPeersStream().listen((devicesList) {
            setState(() {
              studentDevices = devicesList;
              if (devicesList.isNotEmpty) {
                updateMessage('Found ${studentDevices.length} student(s)');
              } else {
                updateMessage('No student devices found.');
              }
            });
          });
        } else {
          updateMessage('Discovery failed. Please check your device settings.');
        }
      } catch (e) {
        print(e);
        updateMessage('An error occurred: $e');
      }
    } else {
      updateMessage('Wi-Fi is not enabled. Please enable Wi-Fi to continue.');
    }
  }

  void stopSearching() {
    setState(() {
      isSearching = false;
      message = 'Search stopped after 20 seconds.';
      remainingTime = 0;
    });
    nearbyService.stopDiscovery();
    searchTimer?.cancel();
  }

  void updateMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  @override
  void dispose() {
    searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher - Taking Attendance')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$remainingTime',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: studentDevices.isEmpty
                ? Center(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: studentDevices.length,
                    itemBuilder: (context, index) {
                      final device = studentDevices[index];
                      return ListTile(
                        title: Text(
                          device.info.displayName ?? 'Unknown Device',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(device.info.id),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  isSearching ? null : requestPermissionsAndStartSearching,
              child: isSearching
                  ? const Text('Searching...')
                  : const Text('Start Taking Attendance'),
            ),
          ),
        ],
      ),
    );
  }
}

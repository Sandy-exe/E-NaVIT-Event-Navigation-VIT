import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class GiveAttendance extends StatefulWidget {
  const GiveAttendance({super.key});

  @override
  _GiveAttendanceState createState() => _GiveAttendanceState();
}

class _GiveAttendanceState extends State<GiveAttendance> {
  late NearbyService nearbyService;
  List<NearbyDevice> nearbyDevices = [];
  final String studentId = '21BCE0666';
  String message = 'Welcome! Searching for teacher devices...';
  bool isSearching = false;
  Timer? searchTimer;
  int timeLeft = 20; // Time in seconds

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
      setState(() {
        message = 'Please enable location and Bluetooth permissions.';
      });
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
        message = 'Searching for teacher devices...';
        timeLeft = 20; // Reset timer
      });

      final result = await nearbyService.discover();
      if (result) {
        nearbyService.getPeersStream().listen((devicesList) {
          setState(() {
            nearbyDevices = devicesList;
            message = nearbyDevices.isNotEmpty
                ? 'Found ${nearbyDevices.length} teacher device(s)'
                : 'No devices found';
          });
        });
      } else {
        setState(() {
          message = 'Failed to discover nearby devices';
        });
      }

      // Start the countdown timer
      startCountdown();
    }
  }

  void startCountdown() {
    searchTimer?.cancel(); // Cancel any previous timer
    searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        stopSearching();
      }
    });
  }

  void stopSearching() {
    setState(() {
      isSearching = false;
      message = 'Search ended';
    });
    nearbyService.stopDiscovery();
    searchTimer?.cancel();
  }

  void sendAttendance() async {
    if (nearbyDevices.isNotEmpty) {
      for (var teacherDevice in nearbyDevices) {
        await nearbyService.send(
          OutgoingNearbyMessage(
            content: NearbyMessageTextRequest.create(value: studentId),
            receiver: teacherDevice.info,
          ),
        );
        setState(() {
          message =
              'Attendance sent to: ${teacherDevice.info.displayName} (ID: $studentId)';
        });
      }
    } else {
      setState(() {
        message = 'No teacher devices found to send attendance';
      });
    }
  }

  @override
  void dispose() {
    searchTimer?.cancel();
    nearbyService.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student - Give Attendance')),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: timeLeft / 20,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 12.0,
                          backgroundColor: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                      Text(
                        '$timeLeft',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: nearbyDevices.length,
                    itemBuilder: (context, index) {
                      final device = nearbyDevices[index];
                      return ListTile(
                        title:
                            Text(device.info.displayName ?? 'Unknown Device'),
                        subtitle: Text('ID: ${device.info.id}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isSearching ? null : sendAttendance,
              child: isSearching
                  ? const Text('Searching...')
                  : const Text('Send Attendance'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:enavit/services/db_helper.dart';
import 'package:enavit/services/firebase_sync.dart';

class TakeAttendance extends StatefulWidget {
  final String eventId; // Pass eventId as a parameter

  const TakeAttendance({super.key, required this.eventId});

  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  final MobileScannerController controller = MobileScannerController();
  final DatabaseHelper dbHelper = DatabaseHelper();
  final SyncService syncService = SyncService(); // Instance of SyncService
  String? result;
  bool isSyncing = false; // Track syncing state

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture barcode) {
    print(barcode);
    final Barcode userId_barcode = barcode.barcodes.first;
    final String? userId = userId_barcode.rawValue;
    print(userId);
    if (userId != null && userId != result) {
      setState(() {
        result = userId;
      });
      _handleScan(userId);
    }
  }

  Future<void> _handleScan(String userId) async {
    final attendee = await dbHelper.getAttendee(widget.eventId, userId);

    if (attendee != null) {
      await dbHelper.markAttendance(widget.eventId, userId);
      _showDialog(
        title: 'Attendance Marked',
        message: 'User: ${attendee['name']} (ID: $userId) marked as attended.',
      );
    } else {
      _showDialog(
        title: 'Not Registered',
        message: 'User ID $userId is not registered for this event.',
      );
    }
  }

  Future<void> _syncData() async {
    setState(() {
      isSyncing = true; // Start syncing
    });

    bool success = await syncService.syncAndCheckAttendance(widget.eventId);

    setState(() {
      isSyncing = false; // End syncing
    });

    if (success) {
      _showDialog(
        title: 'Sync Completed',
        message: 'Data synced successfully for event ID: ${widget.eventId}',
      );
    } else {
      _showDialog(
        title: 'Sync Failed',
        message: 'Failed to sync data. Please try again.',
      );
    }
  }

  void _showDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          ElevatedButton(
            onPressed: isSyncing ? null : _syncData,
            child: isSyncing
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: null,
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      const Text('Syncing...'),
                    ],
                  )
                : const Text('Sync Data'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) => _onDetect(capture),
              fit: BoxFit.cover,
              overlayBuilder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 10,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Scanned Data: $result')
                  : const Text('Scan a QR code'),
            ),
          ),
          // Sync Button
        ],
      ),
    );
  }
}

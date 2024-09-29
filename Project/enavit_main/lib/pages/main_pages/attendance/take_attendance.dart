import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TakeAttendancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take Attendance')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))

              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _takeAttendance,
                        child: Text('Receive Attendance')),
                    ValueListenableBuilder<dynamic>(
                      valueListenable: result,
                      builder: (context, value, _) => Text('${value ?? ''}'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _takeAttendance() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not NDEF';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        final ndefMessage = ndef.cachedMessage;
        if (ndefMessage == null) {
          result.value = 'No data found';
          NfcManager.instance.stopSession();
          return;
        }

        String attendanceData = '';
        for (var record in ndefMessage.records) {
          if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
              record.payload.isNotEmpty) {
            attendanceData = String.fromCharCodes(record.payload);
          }
        }

        result.value = 'Attendance Data Received: $attendanceData';
        await _processAttendance(attendanceData); // Simulate database check
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = 'Failed to read tag: $e';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
      }
    });
  }

  Future<void> _processAttendance(String data) async {
    // Simulate checking database and marking attendance
    await Future.delayed(Duration(seconds: 2)); // Placeholder for DB check
    result.value = 'Attendance Marked Successfully for $data';
  }
}

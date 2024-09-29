import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class GiveAttendancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GiveAttendancePageState();
}

class _GiveAttendancePageState extends State<GiveAttendancePage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Give Attendance')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _giveAttendance,
                        child: Text('Send Attendance')),
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

  void _giveAttendance() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'NFC tag not writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('Student ID: 12345'),
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList('Attendance Data'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Attendance Sent';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = 'Failed to send: $e';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
      }
    });
  }
}

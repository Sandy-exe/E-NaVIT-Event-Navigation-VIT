import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GiveAttendance extends StatelessWidget {
  final String userId; // This should be the logged-in participant's user ID

  const GiveAttendance({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    print(userId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: userId,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(80, 80),
          ),
          errorStateBuilder: (context, error) {
            return const Center(
              child: Text(
                'Uh oh! Something went wrong...',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

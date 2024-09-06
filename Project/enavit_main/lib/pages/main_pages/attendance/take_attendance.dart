import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TakeAttendance extends StatelessWidget {
  final String qrData;
  final String? embeddedImagePath;

  const TakeAttendance({
    super.key,
    required this.qrData,
    this.embeddedImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          embeddedImage:
              embeddedImagePath != null ? AssetImage(embeddedImagePath!) : null,
          embeddedImageStyle: embeddedImagePath != null
              ? const QrEmbeddedImageStyle(
                  size: Size(80, 80),
                )
              : null,
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

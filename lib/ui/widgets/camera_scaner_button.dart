import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

class CameraScanerButton extends StatelessWidget {
  const CameraScanerButton({super.key, required this.scan});

  final Function(String) scan;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((ctx) => AiBarcodeScanner(
                        controller: MobileScannerController(
                          detectionTimeoutMs: 1000,
                          detectionSpeed: DetectionSpeed.normal,
                        ),
                      ))));
        },
        icon: const Icon(Icons.qr_code_scanner_rounded));
  }
}

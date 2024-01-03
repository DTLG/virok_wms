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
                        onScan: (value) {
                          var a = value.trim();
                          scan(a);
                        },
                        controller: MobileScannerController(
                          detectionTimeoutMs: 1000,
                          detectionSpeed: DetectionSpeed.normal,
                        ),
                      ))));
        },
        icon: const Icon(Icons.qr_code_scanner_rounded));

    InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((ctx) => AiBarcodeScanner(
                      onScan: (value) {
                        var a = value.trim();
                        scan(a);
                      },
                      controller: MobileScannerController(
                        detectionTimeoutMs: 1000,
                        detectionSpeed: DetectionSpeed.normal,
                      ),
                    ))));
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Stack(
          children: [
            Image.asset(
              'assets/icons/scaner_icon.png',
              width: 40,
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                width: 23,
                height: 23,
                color: const Color.fromARGB(113, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

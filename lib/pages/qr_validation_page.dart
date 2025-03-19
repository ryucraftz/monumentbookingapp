import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRValidationPage extends StatefulWidget {
  const QRValidationPage({super.key});

  @override
  State<QRValidationPage> createState() => _QRValidationPageState();
}

class _QRValidationPageState extends State<QRValidationPage> {
  MobileScannerController cameraController = MobileScannerController();
  String scannedData = "Scan a QR code";
  bool isScanning = true;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleQRCodeDetected(String qrData) {
    // Stop the camera
    cameraController.stop();
    setState(() {
      isScanning = false;
      scannedData = qrData; // Update the scanned data
    });

    // Show the scanned data in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("QR Code Scanned"),
        content: Text(
          "Scanned Data: $qrData",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Restart the camera for the next scan
              setState(() {
                isScanning = true;
                scannedData = "Scan a QR code";
              });
              cameraController.start();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Validation"),
        backgroundColor: const Color(0xff6351ec),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: isScanning
                ? MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        String qrData = barcodes.first.rawValue ?? "No data found";
                        _handleQRCodeDetected(qrData); // Handle the scanned data
                      }
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Scanning paused.",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Scanned Data: $scannedData",
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedData,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
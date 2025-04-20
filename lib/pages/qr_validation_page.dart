import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRValidationPage extends StatefulWidget {
  const QRValidationPage({super.key});

  @override
  State<QRValidationPage> createState() => _QRValidationPageState();
}

class _QRValidationPageState extends State<QRValidationPage>
    with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  String scannedData = "Scan a QR code";
  bool isScanning = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _handleQRCodeDetected(String qrData) {
    // Stop the camera
    cameraController.stop();
    setState(() {
      isScanning = false;
      scannedData = qrData;
    });

    // Show the scanned data in a custom dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xff6351ec).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xff6351ec),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "QR Code Scanned Successfully!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      qrData,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          isScanning = true;
                          scannedData = "Scan a QR code";
                        });
                        cameraController.start();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6351ec),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Scan Another Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xff6351ec),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "QR Code Scanner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Scanner Section
            Expanded(
              child: Stack(
                children: [
                  isScanning
                      ? MobileScanner(
                        controller: cameraController,
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            String qrData =
                                barcodes.first.rawValue ?? "No data found";
                            _handleQRCodeDetected(qrData);
                          }
                        },
                      )
                      : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                size: 50,
                                color: Color(0xff6351ec),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Scanning Paused",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                  // Scanner Overlay
                  if (isScanning)
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff6351ec),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomPaint(painter: ScannerOverlayPainter()),
                      ),
                    ),
                ],
              ),
            ),

            // Status Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    scannedData,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (!isScanning)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isScanning = true;
                          scannedData = "Scan a QR code";
                        });
                        cameraController.start();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6351ec),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("Resume Scanning"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xff6351ec)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw corner lines
    final cornerLength = 20.0;
    final cornerWidth = 2.0;

    // Top-left corner
    canvas.drawLine(
      Offset(0, cornerLength),
      Offset(0, 0),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(0, 0),
      Offset(cornerLength, 0),
      paint..strokeWidth = cornerWidth,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint..strokeWidth = cornerWidth,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint..strokeWidth = cornerWidth,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(cornerLength, size.height),
      Offset(0, size.height),
      paint..strokeWidth = cornerWidth,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint..strokeWidth = cornerWidth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

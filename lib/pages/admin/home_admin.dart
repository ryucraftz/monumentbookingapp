import 'package:flutter/material.dart';
import 'package:monumentbookingapp/pages/admin/ticket_event.dart';
import 'package:monumentbookingapp/pages/admin/upload_event.dart';
import 'package:monumentbookingapp/pages/qr_validation_page.dart'; // Import the QR validation page

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50.0),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Back Button and Title
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  // Centered Title
                  Expanded(
                    child: Text(
                      "Home Admin",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // White Container for Buttons
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),

                      // Upload Events Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to UploadEvent Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadEvent(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6351ec),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 40.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "Upload Monuments",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Event Tickets Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to TicketEvent Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketEvent(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6351ec),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 40.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "Monument Tickets",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // QR Validation Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to QR Validation Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRValidationPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6351ec),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 40.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "Validate QR Code",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
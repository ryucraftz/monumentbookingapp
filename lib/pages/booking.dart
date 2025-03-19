import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monumentbookingapp/services/database.dart';
import 'package:monumentbookingapp/services/shared_pref.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import the qr_flutter package

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookingStream;
  String? id;

  getthesahredpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesahredpref();
    bookingStream = await DatabaseMethods().getbookings(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

Widget allbookings() {
  return StreamBuilder(
    stream: bookingStream,
    builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return GestureDetector(
                  onTap: () {
                    // Show QR code when the booking is tapped
                    if (ds["QRData"] != null && ds["QRData"].isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Container(
                            width: 300, // Provide a fixed width
                            height: 300, // Provide a fixed height
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Booking Details",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                QrImageView(
                                  data: ds["QRData"], // Use the QRData from Firestore
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                                SizedBox(height: 20),
                                Text("Scan this QR code for entry"),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text("QR code data not found for this booking."),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: Colors.blue),
                            const SizedBox(width: 10.0),
                            Text(
                              ds["Location"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds["Image"],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds["Event"],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          ds["Date"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.group,
                                            color: Colors.blue),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          ds["Number"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          "\$" + ds["Total"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ); // Show a loader while data is loading
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              "Bookings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: allbookings(),
            ),
          ),
        ],
      ),
    );
  }
}
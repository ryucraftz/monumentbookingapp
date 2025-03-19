import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monumentbookingapp/services/database.dart';

class TicketEvent extends StatefulWidget {
  const TicketEvent({super.key});

  @override
  State<TicketEvent> createState() => _TicketEventState();
}

class _TicketEventState extends State<TicketEvent> {
  Stream? ticketStream;

  ontheload() async {
    ticketStream = await DatabaseMethods().getTickets();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Widget allTickets() {
    return StreamBuilder(
      stream: ticketStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
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
                                        fontSize: 16.0,
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
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          ds["Name"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.group,
                                            color: Colors.blue),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          ds["Number"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
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
                                            fontSize: 16.0,
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
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, top: 40.0),
          child: Column(
            children: [
              // Back Button and Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 4.5),
                  const Text(
                    "Monument Tickets",
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Tickets List
              allTickets(),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monumentbookingapp/services/database.dart';

class TicketEvent extends StatefulWidget {
  const TicketEvent({super.key});

  @override
  State<TicketEvent> createState() => _TicketEventState();
}

class _TicketEventState extends State<TicketEvent>
    with SingleTickerProviderStateMixin {
  Stream? ticketStream;
  bool _isLoading = false;
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
    ontheload();
  }

  ontheload() async {
    setState(() => _isLoading = true);
    ticketStream = await DatabaseMethods().getTickets();
    setState(() => _isLoading = false);
  }

  Future<String?> _getEventImage(String eventName) async {
    try {
      print('Fetching image for event: $eventName'); // Debug log
      final eventDoc =
          await FirebaseFirestore.instance
              .collection('Events')
              .where('Name', isEqualTo: eventName)
              .get();

      print('Found ${eventDoc.docs.length} matching events'); // Debug log

      if (eventDoc.docs.isNotEmpty) {
        final imageUrl = eventDoc.docs.first.get('Image') as String?;
        print('Image URL found: $imageUrl'); // Debug log
        return imageUrl;
      }
      print('No matching event found'); // Debug log
      return null;
    } catch (e) {
      print('Error fetching event image: $e');
      return null;
    }
  }

  Widget _buildTicketCard(DocumentSnapshot ds) {
    final Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    final eventName = data["Event"] as String?;
    // Try EventImage first, fall back to Image if not found
    final eventImage =
        data["EventImage"] as String? ?? data["Image"] as String?;
    print('Building ticket card for event: $eventName');
    print('Event Image URL: $eventImage');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Location Header
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xff6351ec).withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xff6351ec),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ds["Location"],
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ticket Details
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monument Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:
                          eventImage != null && eventImage.isNotEmpty
                              ? Image.network(
                                eventImage,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xff6351ec),
                                            ),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                              : Container(
                                height: 120,
                                width: 120,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                    const SizedBox(width: 15),

                    // Ticket Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Event"],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Date
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                ds["Date"],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Visitor Name
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                ds["Name"],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Number of Tickets and Total
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.group,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${ds["Number"]} tickets",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.monetization_on,
                                  color: Colors.purple,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "\$${ds["Total"]}",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
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
      ),
    );
  }

  Widget allTickets() {
    return StreamBuilder(
      stream: ticketStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6351ec)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  "No tickets found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Tickets will appear here",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return _buildTicketCard(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xff6351ec),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Monument Tickets",
                      style: TextStyle(
                        color: Color(0xff6351ec),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Tickets List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: allTickets(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

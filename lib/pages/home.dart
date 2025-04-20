import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:monumentbookingapp/pages/categories_event.dart';
import 'package:monumentbookingapp/pages/detail_page.dart';
import 'package:monumentbookingapp/services/database.dart';
import 'package:monumentbookingapp/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? eventStream;
  int eventnumber = 0;
  String? _currentCity, name;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  getthesahredpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  Future<void> _getCurrentCity() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _currentCity = "Permission Denied";
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          _currentCity = placemarks.first.locality;
        });
      } else {
        setState(() {
          _currentCity = "City not found";
        });
      }
    } catch (e) {
      setState(() {
        _currentCity = "Error: $e";
      });
    }
  }

  void ontheload() async {
    await getthesahredpref();
    eventStream = await DatabaseMethods().getallEvents();
    _getCurrentCity();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentCity == null
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6351ec)),
                ),
              )
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.only(top: 50.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffe3e6ff),
                        Color(0xfff1f3ff),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location and Greeting Section
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff6351ec),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _currentCity!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Hello, $name!",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "There are $eventnumber monuments\naround your location.",
                        style: const TextStyle(
                          color: Color(0xff6351ec),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Search Bar
                      Hero(
                        tag: 'searchBar',
                        child: Material(
                          color: Colors.transparent,
                          child: searchBar(),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Categories Section
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildCategoryCard("Mumbai", "images/mumbai.png"),
                            const SizedBox(width: 20.0),
                            _buildCategoryCard("Pune", "images/pune.png"),
                            const SizedBox(width: 20.0),
                            _buildCategoryCard(
                              "Banglore",
                              "images/banglore.png",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Available Bookings Section
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Available Bookings",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Add see all functionality
                              },
                              child: const Text(
                                "See all",
                                style: TextStyle(
                                  color: Color(0xff6351ec),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      allEvents(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildCategoryCard(String city, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesEvent(eventcategory: city),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  city,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search monuments...",
          prefixIcon: const Icon(Icons.search, color: Color(0xff6351ec)),
          border: InputBorder.none,
          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xff6351ec)),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                        searchQuery = "";
                      });
                    },
                  )
                  : null,
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6351ec)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
            child: Text(
              "No events available",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            if (_currentCity == ds["Location"]) {
              eventnumber = eventnumber + 1;
            }

            String inputDate = ds["Date"];
            DateTime parsedDate = DateTime.parse(inputDate);
            String formattedDate = DateFormat('MMM, dd').format(parsedDate);

            DateTime currentDate = DateTime.now();
            bool hasPassed = currentDate.isAfter(parsedDate);

            // Check if the event matches the search query
            bool matchesSearch =
                searchQuery.isEmpty ||
                ds["Name"].toString().toLowerCase().contains(searchQuery) ||
                ds["Location"].toString().toLowerCase().contains(searchQuery) ||
                formattedDate.toLowerCase().contains(searchQuery);

            return hasPassed || !matchesSearch
                ? Container()
                : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailPage(
                              date: ds["Date"],
                              detail: ds["Detail"],
                              image: ds["Image"],
                              name: ds["Name"],
                              location: ds["Location"],
                              price: ds["Price"],
                            ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 20.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Ensure the Column doesn't expand
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                ds["Image"], // Use the URL from Firestore
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (
                                  BuildContext context,
                                  Object exception,
                                  StackTrace? stackTrace,
                                ) {
                                  return Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0, top: 10.0),
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  formattedDate,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ds["Name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                "\$" + ds["Price"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff6351ec),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              ds["Location"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50.0, left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                Text(
                  "Agra, North India",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              "Hello, Saurabh",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "There are 3 monuments\naround your location.",
              style: TextStyle(
                color: Color(0xff6351ec),
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.only(right: 20.0),
              padding: EdgeInsets.only(left: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search_outlined),
                  border: InputBorder.none,
                  hintText: "Search a Monument",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/cultural.png",
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Cultural",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/natural.png",
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Natural",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/mixed.png",
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Mixed",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Bookings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.only(right: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/agra.jpg",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
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
                        "Aug\n24",
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
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Taj-Mahal Heritage Site",
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
                    "\$12.61",
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
            Row(children: [
              Icon(Icons.location_on),
              Text(
                "Agra, India",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500
                ),
              ),
            ],)
          ],
        ),
      ),
      
    );
  }
}

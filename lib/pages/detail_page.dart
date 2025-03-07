import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/agra.jpg",
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 40.0, left: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black45),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Taj-Mahal Heritage Site",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_month, color: Colors.white),
                                SizedBox(width: 10.0),
                                Text(
                                  "31 Mar 2025",
                                  style: TextStyle(
                                    color: Color.fromARGB(211, 255, 255, 255),
                                    fontSize: 19.0,
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  "Agra, India",
                                  style: TextStyle(
                                    color: Color.fromARGB(211, 255, 255, 255),
                                    fontSize: 19.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "About Monument",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monumentbookingapp/pages/detail_page.dart';
import 'package:monumentbookingapp/services/database.dart';

class CategoriesEvent extends StatefulWidget {
  final String eventcategory;
  CategoriesEvent({required this.eventcategory});

  @override
  State<CategoriesEvent> createState() => _CategoriesEventState();
}

class _CategoriesEventState extends State<CategoriesEvent> {
  Stream? eventStream;

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  getontheload() async {
    eventStream = await DatabaseMethods().getEventCategories(widget.eventcategory);
    setState(() {});
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  String inputDate = ds["Date"];
                  DateTime parsedDate = DateTime.parse(inputDate);
                  String formattedDate = DateFormat('MMM, dd').format(parsedDate);

                  DateTime currentDate = DateTime.now();
                  bool hasPassed = currentDate.isAfter(parsedDate);

                  return hasPassed
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
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
                            margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        ds["Image"],
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
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
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
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 10.0,
                                        top: 10.0,
                                      ),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
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
                                ),
                              ],
                            ),
                          ),
                        );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 3.5),
                      Text(
                        widget.eventcategory,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      allEvents(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:monumentbookingapp/services/database.dart';
import 'package:monumentbookingapp/services/shared_pref.dart';

class DetailPage extends StatefulWidget {
  final String image, name, location, date, detail, price;
  DetailPage({
    required this.date,
    required this.detail,
    required this.image,
    required this.name,
    required this.location,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? paymentIntent;
  int ticket = 1;
  int total = 0;
  String? name, image, id;

  @override
  void initState() {
    total = int.parse(widget.price);
    ontheload();
    super.initState();
  }

  ontheload() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.image,
                  height: MediaQuery.of(context).size.height / 2,
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
                            loadingProgress.expectedTotalBytes != null
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
                    return Center(child: Text('Failed to load image'));
                  },
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
                              widget.name,
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
                                  widget.date,
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
                                  widget.location,
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
            SizedBox(height: 20.0),
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
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.detail,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text(
                    "Number of Tickets",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            total = total + int.parse(widget.price);
                            ticket = ticket + 1;
                            setState(() {});
                          },
                          child: Text(
                            "+",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        Text(
                          ticket.toString(),
                          style: TextStyle(
                            color: Color(0xff6351ec),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (ticket > 1) {
                              total = total - int.parse(widget.price);
                              ticket = ticket - 1;
                              setState(() {});
                            }
                          },
                          child: Text(
                            "-",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Amount : \$" + total.toString(),
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      print("Book Now button clicked");
                      makePayment(total.toString());
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff6351ec),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      print("makePayment() started with amount: $amount");
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Your Merchant',
        ),
      );
      displayPaymentSheet();
    } catch (e) {
      print('Error: $e');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Map<String, dynamic> bookingdetail = {
        "Number": ticket.toString(),
        "Total": total.toString(),
        "Event": widget.name,
        "Location": widget.location,
        "Date": widget.date,
        "Name": name,
        "Image": image,
      };
      await DatabaseMethods().addUserBooking(bookingdetail, id!).then((
        value,
      ) async {
        await DatabaseMethods().addAdminTickets(bookingdetail);
      });
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Payment Successful"),
                ],
              ),
            ),
      );
      paymentIntent = null;
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text("Payment Cancelled")),
      );
    }
  }

 Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
  try {
    print("Creating Payment Intent with amount: $amount, currency: $currency");

    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer sk_test_51R36tuKXoPvqIoMiYseEx6lu5JPg3C9sy7H3nMVtHHlZylFHqjVrSKpSdaUiUZMylf7RVr5vyd2b8bgmezphVnnI00zljXseS6', // 🔥 Ensure this is correct!
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    print("Stripe API Response Status: ${response.statusCode}");
    print("Stripe API Response Body: ${response.body}");

    if (response.statusCode != 200) {
      print("Error: Failed to create payment intent!");
      return {};
    }

    return jsonDecode(response.body);
  } catch (err) {
    print('Error in createPaymentIntent(): ${err.toString()}'); // ❌ Logs any errors
    return {};
  }
}


  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}

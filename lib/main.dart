import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:monumentbookingapp/pages/admin/admin_login.dart';
import 'package:monumentbookingapp/pages/admin/home_admin.dart';
import 'package:monumentbookingapp/pages/admin/ticket_event.dart';
import 'package:monumentbookingapp/pages/admin/upload_event.dart';
import 'package:monumentbookingapp/pages/booking.dart';
import 'package:monumentbookingapp/pages/bottomnav.dart';
import 'package:monumentbookingapp/pages/categories_event.dart';
import 'package:monumentbookingapp/pages/home.dart';
import 'package:monumentbookingapp/pages/signup.dart';
import 'package:monumentbookingapp/services/data.dart'; // Assuming this is needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishdkey; // Corrected method name
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SignUp(), // Set the initial screen to SignUp
      routes: {'/HomeAdmin': (context) => const HomeAdmin()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

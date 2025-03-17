import 'package:flutter/material.dart';
import 'package:monumentbookingapp/services/auth.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  // Controllers for the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Make the page scrollable
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Image
            Image.asset("images/onboarding.png"),
            const SizedBox(height: 10.0),

            // Title
            const Text(
              "Admin Panel",
              style: TextStyle(
                color: Color(0xff6351ec),
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50.0),

            // Username TextField
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Enter username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person), // Optional: Add an icon
              ),
            ),
            const SizedBox(height: 20.0),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide the password
              decoration: const InputDecoration(
                hintText: "Enter password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock), // Optional: Add an icon
              ),
            ),
            const SizedBox(height: 30.0),

            // Login Button
            ElevatedButton(
              onPressed: () {
                _authMethods.adminLogin(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  context: context,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6351ec), // Button color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
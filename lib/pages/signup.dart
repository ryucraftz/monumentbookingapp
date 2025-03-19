import 'package:flutter/material.dart';
import 'package:monumentbookingapp/pages/admin/admin_login.dart';
import 'package:monumentbookingapp/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the Column doesn't expand
            children: [
              // Image
              Image.asset("images/onboarding.png"),
              const SizedBox(height: 10.0),

              // Title Text
              const Text(
                "Unlock the Future of",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Monument Seeing",
                style: TextStyle(
                  color: Color(0xff6351ec),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),

              // Subtitle Text
              const Text(
                "Discover, book, and experience\nunforgettable moments effortlessly!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 50.0),

              // Google Sign-Up Button
              Container(
                height: 70,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                decoration: BoxDecoration(
                  color: const Color(0xff6351ec),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: GestureDetector(
                  onTap: () {
                    AuthMethods().signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/google.png",
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // Admin Panel Button
              GestureDetector(
                onTap: () {
                  // Navigate to the AdminLogin page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminLogin()),
                  );
                },
                child: const Text(
                  "Admin Panel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0), // Add extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monumentbookingapp/pages/bottomnav.dart';
import 'package:monumentbookingapp/pages/admin/home_admin.dart'; // Import your admin home page
import 'package:monumentbookingapp/services/database.dart';
import 'package:monumentbookingapp/services/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get Current User
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  // Google Sign-In Method (Unchanged)
  Future<void> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;
    await SharedPreferenceHelper().saveUserEmail(userDetails!.email!);
    await SharedPreferenceHelper().saveUserName(userDetails.displayName!);
    await SharedPreferenceHelper().saveUserImage(userDetails.photoURL!);
    await SharedPreferenceHelper().saveUserId(userDetails.uid);

    if (result.user != null) {
      Map<String, dynamic> userInfoMap = {
        "Name": userDetails.displayName,
        "Image": userDetails.photoURL,
        "Email": userDetails.email,
        "Id": userDetails.uid,
      };

      await DatabaseMethods().addUserDetail(userInfoMap, userDetails.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully!!!",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }
  }

  // Admin Login with Email and Password
  Future<void> adminLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is an admin (you can add additional logic here)
      if (userCredential.user != null) {
        // Save admin details to shared preferences (optional)
        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserId(userCredential.user!.uid);

        // Navigate to the Admin Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeAdmin()),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Admin Login Successful!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors
      String errorMessage = "Login Failed. Please try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "No admin found with this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "An error occurred. Please try again.",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  // Sign Out Method
    Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
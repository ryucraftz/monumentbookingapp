import 'package:flutter/material.dart';
import 'package:monumentbookingapp/pages/signup.dart';
import 'package:monumentbookingapp/services/auth.dart';
import 'package:monumentbookingapp/services/shared_pref.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email, id;

  getthesahredpref() async {
    id = await SharedPreferenceHelper().getUserId();
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesahredpref();
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
      body: image == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 50.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
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
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              image!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          _buildProfileInfoRow(
                            icon: Icons.person,
                            title: "Name",
                            value: name!,
                          ),
                          SizedBox(height: 30.0),
                          _buildProfileInfoRow(
                            icon: Icons.mail,
                            title: "Email",
                            value: email!,
                          ),
                          SizedBox(height: 30.0),
                          _buildActionRow(
                            icon: Icons.contact_emergency,
                            title: "Contact Us",
                            onTap: () {
                              // Add contact us functionality
                            },
                          ),
                          SizedBox(height: 30.0),
                          _buildActionRow(
                            icon: Icons.logout,
                            title: "Logout",
                            onTap: () {
                              AuthMethods().SignOut().then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              });
                            },
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(left: 30.0, right: 30.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 30.0,
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
        margin: EdgeInsets.only(left: 30.0, right: 30.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 30.0,
            ),
            SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
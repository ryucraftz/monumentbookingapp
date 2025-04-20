import 'package:flutter/material.dart';
import 'package:monumentbookingapp/pages/signup.dart';
import 'package:monumentbookingapp/services/auth.dart';
import 'package:monumentbookingapp/services/shared_pref.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String? image, name, email, id;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

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
    super.initState();
    ontheload();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    try {
      await AuthMethods().SignOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          image == null
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6351ec)),
                ),
              )
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
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
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Profile",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Profile Card
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Profile Image
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xff6351ec,
                                              ).withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              60,
                                            ),
                                            child: Image.network(
                                              image!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xff6351ec)),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // User Name
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    bottom: 10.0,
                                  ),
                                  child: Text(
                                    name!,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // User Email
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: Text(
                                    email!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),

                                // Profile Info Section
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildProfileInfoRow(
                                    icon: Icons.person,
                                    title: "Name",
                                    value: name!,
                                  ),
                                ),
                                const SizedBox(height: 15.0),

                                SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildProfileInfoRow(
                                    icon: Icons.mail,
                                    title: "Email",
                                    value: email!,
                                  ),
                                ),
                                const SizedBox(height: 15.0),

                                // Action Buttons
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildActionRow(
                                    icon: Icons.contact_emergency,
                                    title: "Contact Us",
                                    onTap: () {
                                      // Add cmontact us functionality
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15.0),

                                SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildActionRow(
                                    icon: Icons.logout,
                                    title: "Logout",
                                    onTap: _isLoading ? null : _handleLogout,
                                    isLoading: _isLoading,
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff6351ec).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xff6351ec), size: 24.0),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: title == "Logout" ? Colors.red[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: title == "Logout" ? Colors.red[200]! : Colors.grey[200]!,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      title == "Logout"
                          ? Colors.red[100]
                          : const Color(0xff6351ec).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        )
                        : Icon(
                          icon,
                          color:
                              title == "Logout"
                                  ? Colors.red
                                  : const Color(0xff6351ec),
                          size: 24.0,
                        ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: title == "Logout" ? Colors.red : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: title == "Logout" ? Colors.red : Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

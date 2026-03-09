import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // Screen ki width check karne ke liye
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 800;
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // 1. Left Side Banner (Sirf Desktop/Web ke liye)
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Container(
                color: const Color(0xFF6366F1), // Purple background
                child: Stack(
                  children: [
                    // Background pattern ya image yahan lagayein
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Very good works are waiting for you Login Now!!!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(20),
                            // User Image Placeholder
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://via.placeholder.com/300x400', // Apni image asset lagayein
                                height: 400,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 2. Right Side Login Form
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : width * 0.05,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.pinkAccent, Colors.purpleAccent],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  const Gap(30),
                  Text(
                    "Login to your account",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "Let's connect, chat, and spark real connections. Enter your credentials to continue your journey.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Gap(30),

                  // Email Field
                  const Text(
                    "Enter your Email",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  MyTextField(
                    hintText: "demo@admin.com",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const Gap(20),

                  // Password Field
                  const Text(
                    "Enter your Password",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  MyTextField(
                    hintText: "••••••••",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off_outlined),
                  ),
                  const Gap(15),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (v) {}),
                          const Text("Remember me?"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?"),
                      ),
                    ],
                  ),
                  const Gap(30),

                  // Buttons Grid
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildButton("Admin Log In", const Color(0xFF6366F1)),
                      _buildButton("Staff Log In", Colors.grey),
                      _buildButton("Demo Log In", Colors.redAccent),
                      _buildButton("Demo Staff Log In", Colors.orangeAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}

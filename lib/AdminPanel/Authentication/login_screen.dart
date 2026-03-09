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
    final double width = MediaQuery.of(context).size.width;
    // Agar screen width 900 se kam hai to mobile layout dikhayenge
    final bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // --- LEFT SIDE: IMAGE/BANNER (Sirf Desktop/Web ke liye) ---
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1), // Light grey background
                ),
                child: Center(
                  child: Image.network(
                    'https://img.freepik.com/free-vector/tablet-login-concept-illustration_114360-7863.jpg',
                    fit: BoxFit.contain,
                    width: width * 0.4,
                  ),
                ),
              ),
            ),

          // --- RIGHT SIDE: LOGIN FORM ---
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 30 : width * 0.08,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tingle Logo (Jaisa image mein tha)
                    Center(
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const Gap(30),

                    Text(
                      "Login to your account",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Gap(10),
                    const Text(
                      "Let's connect, chat, and spark real connections.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Gap(40),

                    // Email Input
                    const Text(
                      "Enter your Email",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "demo@admin.com",
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                    const Gap(20),

                    // Password Input
                    const Text(
                      "Enter your Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: const Icon(
                          Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),

                    const Gap(15),
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
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),

                    // --- ONLY ADMIN LOGIN BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF6366F1,
                          ), // Primary Indigo color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Get.offAllNamed(AppRoutes.mainscreen);
                        },
                        child: const Text(
                          "Admin Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

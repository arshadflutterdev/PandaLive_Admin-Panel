import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    final bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // --- LEFT SIDE: EXACT IMAGE DESIGN (Shape + Text) ---
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1), // Main Purple Background
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    // --- Yeh hai wo Vertical Inner Shape ---
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width * 0.35, // Vertical width
                        height:
                            MediaQuery.of(context).size.height *
                            0.85, // Long Vertical shape
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            0.15,
                          ), // Light transparent color
                          borderRadius: BorderRadius.circular(
                            40,
                          ), // Rounded corners
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    // --- Text on top of the shape ---
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Top se start ho
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Right side aligned
                        children: [
                          const Gap(40),
                          Text(
                            "Very good\nworks are\nwaiting for\nyou Login\nNow!!!",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    // Logo
                    Center(
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          color: Colors.white,
                          size: 45,
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
                      "Let's connect, chat, and spark real connections. Enter your credentials to continue.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Gap(35),

                    const Text(
                      "Enter your Email",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "demo@admin.com",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Gap(20),

                    const Text(
                      "Enter your Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
                    const Gap(30),

                    // Admin Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
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

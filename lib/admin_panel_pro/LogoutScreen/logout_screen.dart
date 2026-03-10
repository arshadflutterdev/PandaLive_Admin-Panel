import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase logout ke liye

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  // --- Firebase Logout Method ---
  Future<void> _performFirebaseLogout() async {
    try {
      // 1. Firebase se logout karein
      await FirebaseAuth.instance.signOut();

      // 2. Login screen par bhej dein aur pichla sara record clear kar dein
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FD,
      ), // Aapke dashboard ka background color
      body: Center(
        child: Container(
          width: 400, // Card ki width
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Orange Warning Icon
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.orangeAccent,
                size: 90,
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                "Are You Sure!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Buttons Row
              Row(
                children: [
                  // CANCEL BUTTON: Is pe click karne se kuch nahi hoga, sirf wapis jayega
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // OK BUTTON: Is pe click karne se Firebase logout hoga
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _performFirebaseLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF8C84FF,
                        ), // Purple color
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

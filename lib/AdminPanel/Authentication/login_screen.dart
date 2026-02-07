import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Buttons/my_elevatedbutton.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Textfields/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> adminlogin() async {
    // 1. Basic Validation
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Email aur Password lazmi likhein",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Loading dikhane ke liye (Optional but recommended)
      // Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

      // 2. Firebase Login Attempt
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 3. Success: Navigate to Sidebar
      Get.offAllNamed(AppRoutes.sidebar);
    } on FirebaseAuthException catch (e) {
      // 4. Firebase Specific Exceptions Catching
      String errorMessage = "Login fail ho gaya";

      if (e.code == 'user-not-found') {
        errorMessage = "Is email se koi admin account nahi mila.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Password galat hai. Dobara check karein.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Email ka format sahi nahi hai.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "Ye admin account disable kar diya gaya hai.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Bohat zyada koshishain! Thori dair baad try karein.";
      }

      Get.snackbar(
        "Login Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      // 5. General Exceptions (Internet issue etc)
      Get.snackbar(
        "Error",
        "Internet ya koi aur masla hai: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Agar loading dialog khola tha toh usay band karne ke liye
      // if (Get.isDialogOpen!) Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text(
            "Welcome Back",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          Gap(8),
          Text(
            "Sign in to manage the admin dashboard",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          Gap(10),
          Center(
            child: SizedBox(
              width: kIsWeb ? width * 0.30 : width * 0.90,
              child: MyTextField(
                controller: emailController,
                label: Text("Email Address"),
              ),
            ),
          ),
          Gap(15),
          SizedBox(
            width: kIsWeb ? width * 0.30 : 50,
            child: MyTextField(
              controller: passwordController,
              label: Text("Password"),
            ),
          ),
          Gap(15),
          SizedBox(
            height: 40,
            width: kIsWeb ? width * 0.30 : width * 0.90,
            child: MyElevatedButton(
              bcolor: Color(0xFF1E3A8A),
              onpressed: () {
                adminlogin();
              },
              child: Text(
                "Login as Admin",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

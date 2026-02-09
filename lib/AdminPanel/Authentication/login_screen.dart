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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: MyTextField(label: Text("Email Address")),
              ),
            ),
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: MyTextField(label: Text("Password")),
            ),
          ),
          Gap(15),
          SizedBox(
            height: 45,
            child: MyElevatedButton(
              bcolor: Color(0xFF1E3A8A),
              onpressed: () {
                Get.toNamed(AppRoutes.sidebar);
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

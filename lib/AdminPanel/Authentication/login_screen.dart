import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
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
          Text("Welcome Back", style: TextStyle(fontSize: 30)),
          Gap(15),
          Text("Login to access administration"),
          Gap(10),
          Center(
            child: SizedBox(
              width: kIsWeb ? width * 0.30 : 50,
              child: MyTextField(label: Text("Add Your Email")),
            ),
          ),
          Gap(15),
          SizedBox(
            width: kIsWeb ? width * 0.30 : 50,
            child: MyTextField(label: Text("Enter Your Password")),
          ),
          Gap(15),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5A27),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Login to Admin Panel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.bg,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.setting);
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
      backgroundColor: AppColours.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text(
            "welcomeback".tr,
            style: isArabic
                ? GoogleFonts.amiri(fontSize: 30, fontWeight: FontWeight.w800)
                : TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          Gap(8),
          Text(
            "managedash".tr,
            style: isArabic
                ? GoogleFonts.amiri(fontSize: 16, color: Colors.grey)
                : TextStyle(fontSize: 14, color: Colors.grey),
          ),

          Gap(10),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: MyTextField(
                  label: Text(
                    "emailadres".tr,
                    style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                  ),
                ),
              ),
            ),
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: MyTextField(
                label: Text(
                  "password".tr,
                  style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                ),
              ),
            ),
          ),
          Gap(15),
          SizedBox(
            height: 45,
            child: MyElevatedButton(
              bcolor: Color(0xFF1E3A8A),
              onpressed: () {
                Get.offAllNamed(AppRoutes.sidebar);
              },
              child: Text(
                "loginadmin".tr,
                style: isArabic
                    ? GoogleFonts.amiri(color: Colors.white)
                    : TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

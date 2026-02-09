import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Buttons/my_elevatedbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void storelanguage(String langCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("language", langCode);
    print("congratulation your language is store");
  }

  void loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString("language"); // 'ar' ya 'en'

    setState(() {
      if (lang == 'ar') {
        isSelected = "Arabic".tr;
      } else {
        isSelected = "English".tr;
      }
    });
  }

  String isSelected = "".tr;
  @override
  void initState() {
    super.initState();
    loadSelectedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isArabic ? "اختر لغتك المفضلة" : "Choice Your Favourite Language",
              style: isArabic ? GoogleFonts.amiri() : TextStyle(),
            ),
            Gap(10),
            SizedBox(
              width: 120,
              child: MyElevatedButton(
                onpressed: () {
                  Get.updateLocale(const Locale('ar', 'AE'));
                  storelanguage("ar");
                  setState(() {
                    isSelected = "Arabic".tr;
                  });
                },
                bcolor: isSelected == "Arabic".tr
                    ? Color(0xff0D1A63)
                    : Colors.white,
                child: Text(
                  "Arabic".tr,
                  style: TextStyle(
                    color: isSelected == "Arabic".tr
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            Gap(5),
            SizedBox(
              width: 120,
              child: MyElevatedButton(
                onpressed: () {
                  Get.updateLocale(const Locale('en', 'US'));
                  storelanguage("en");
                  setState(() {
                    isSelected = "English".tr;
                  });
                },
                bcolor: isSelected == "English".tr
                    ? Color(0xff0D1A63)
                    : Colors.white,
                child: Text(
                  "English".tr,
                  style: TextStyle(
                    color: isSelected == "English".tr
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColours.bg,
    );
  }
}

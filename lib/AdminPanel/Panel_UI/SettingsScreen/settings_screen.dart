import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Buttons/my_elevatedbutton.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String isSelected = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Choice Your Favourite Language"),
            Gap(10),
            SizedBox(
              width: 120,
              child: MyElevatedButton(
                onpressed: () {
                  setState(() {
                    isSelected = "Arabic";
                  });
                },
                bcolor: isSelected == "Arabic"
                    ? Color(0xff0D1A63)
                    : Colors.white,
                child: Text(
                  "Arabic",
                  style: TextStyle(
                    color: isSelected == "Arabic" ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Gap(5),
            SizedBox(
              width: 120,
              child: MyElevatedButton(
                onpressed: () {
                  setState(() {
                    isSelected = "English";
                  });
                },
                bcolor: isSelected == "English"
                    ? Color(0xff0D1A63)
                    : Colors.white,
                child: Text(
                  "English",
                  style: TextStyle(
                    color: isSelected == "English"
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

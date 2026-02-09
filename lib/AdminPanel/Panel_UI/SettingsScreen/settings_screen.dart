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
                onpressed: () {},
                bcolor: Colors.white,
                child: Text("Arabic", style: TextStyle(color: Colors.black)),
              ),
            ),
            Gap(5),
            SizedBox(
              width: 120,
              child: MyElevatedButton(
                onpressed: () {},
                bcolor: Colors.white,
                child: Text("English", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColours.bg,
    );
  }
}

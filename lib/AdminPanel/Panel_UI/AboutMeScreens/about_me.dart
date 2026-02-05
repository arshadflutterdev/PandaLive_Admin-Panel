import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Center(child: Text("About me")),
    );
  }
}

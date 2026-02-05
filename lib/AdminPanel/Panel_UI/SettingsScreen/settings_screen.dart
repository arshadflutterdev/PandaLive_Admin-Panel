import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Settings"), backgroundColor: AppColours.bg);
  }
}

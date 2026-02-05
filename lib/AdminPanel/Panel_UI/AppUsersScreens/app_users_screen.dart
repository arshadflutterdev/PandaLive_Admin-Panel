import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({super.key});

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Center(child: Text("AppUsersScreen")),
    );
  }
}

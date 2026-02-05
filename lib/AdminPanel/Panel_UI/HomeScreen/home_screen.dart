import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/state_manager.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AboutMeScreens/about_me.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AppUsersScreens/app_users_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/GraphScreen/graph_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/SettingsScreen/settings_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/Wallet/wallet_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Center(child: Text("Home Page"))],
      ),
    );
  }
}

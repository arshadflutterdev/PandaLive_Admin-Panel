import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/state_manager.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AppUsersScreens/app_users_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/HomeScreen/home_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/SettingsScreen/settings_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/Wallet/wallet_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class SideBarScreen extends StatefulWidget {
  const SideBarScreen({super.key});

  @override
  State<SideBarScreen> createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  List<String> tabNames = ["Home", "AppUsers", "Wallet", "Settings"];
  List<Icon> tabIcons = [
    Icon(Icons.home),
    Icon(Icons.group),

    Icon(Icons.wallet),
    Icon(Icons.settings),
  ];
  List<Widget> adminScreens = [
    HomeScreen(),
    AppUsersScreen(),
    WalletScreen(),
    SettingsScreen(),
  ];
  RxInt selectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColours.bg,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Color(0xff0D1A63),
          currentIndex: selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            selectedIndex.value = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "ManageUsers",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: "Language",
            ),
          ],
        ),
      ),
      body: Obx(() => adminScreens[selectedIndex.value]),
    );
  }
}

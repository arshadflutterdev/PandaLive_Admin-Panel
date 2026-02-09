import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
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
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: AppColours.bg,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedLabelStyle: isArabic ? GoogleFonts.amiri() : TextStyle(),
          unselectedLabelStyle: isArabic ? GoogleFonts.amiri() : TextStyle(),
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
              label: "home".tr,
            ),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "user".tr),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: "wallet".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: "language".tr,
            ),
          ],
        ),
      ),
      body: Obx(() => adminScreens[selectedIndex.value]),
    );
  }
}

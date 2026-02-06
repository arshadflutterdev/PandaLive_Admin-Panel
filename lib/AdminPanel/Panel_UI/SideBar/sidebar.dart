import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/state_manager.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AboutMeScreens/about_me.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AppUsersScreens/app_users_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/GraphScreen/graph_screen.dart';
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
  List<String> tabNames = [
    "Home",
    "AppUsers",
    "Graph",
    "Wallet",
    "Settings",
    "About Me",
  ];
  List<Icon> tabIcons = [
    Icon(Icons.home),
    Icon(Icons.group),
    Icon(Icons.auto_graph),
    Icon(Icons.wallet),
    Icon(Icons.settings),
    Icon(CupertinoIcons.profile_circled),
  ];
  List<Widget> adminScreens = [
    HomeScreen(),
    AppUsersScreen(),
    GraphScreen(),
    WalletScreen(),
    SettingsScreen(),
    AboutMe(),
  ];
  RxInt selectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Row(
        children: [
          Container(
            width: width * 0.14,
            decoration: BoxDecoration(color: Color(0xff0D1A63)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(10),
                Center(
                  child: Text(
                    "Panda Admin",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                Center(
                  child: Text(
                    "zahrani@gmail.com",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                Gap(20),
                Expanded(
                  child: ListView.builder(
                    itemCount: tabNames.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            selectedIndex.value = index;
                          },
                          child: Obx(
                            () => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: selectedIndex.value == index
                                    ? Colors.black
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Wrap(
                                  spacing: 10,
                                  alignment: WrapAlignment.center,
                                  runSpacing: 10,
                                  children: [
                                    Text(
                                      tabNames[index].toString(),

                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: selectedIndex.value == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      tabIcons[index].icon,
                                      color: selectedIndex.value == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Obx(() => adminScreens[selectedIndex.value]),
            ),
          ),
        ],
      ),
    );
  }
}

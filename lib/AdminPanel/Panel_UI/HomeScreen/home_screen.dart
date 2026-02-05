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
    GraphScreen(),
    SettingsScreen(),
    AppUsersScreen(),
    WalletScreen(),
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
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          child: GestureDetector(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                      ),
                                    ),

                                    tabIcons[index],
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
              child: const Center(child: Text("Yahan Dashboard ka data ayega")),
            ),
          ),
        ],
      ),
    );
  }
}

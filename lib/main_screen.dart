import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> screens = [
    "LiveUser",
    "Wallet",
    "ManageUser",
    "Settings",
    "Notify",
  ];
  List<String> iconss = [
    AppImages.livestream,
    AppImages.wallet,
    AppImages.manage,
    AppImages.settings,
    AppImages.livestream,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: AppColours.bg,
      ),
      body: GridView.builder(
        itemCount: screens.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 120,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Get.toNamed(AppRoutes.home);
              } else if (index == 1) {
                Get.toNamed(AppRoutes.wallet);
              } else if (index == 2) {
                Get.toNamed(AppRoutes.users);
              } else if (index == 3) {
                Get.toNamed(AppRoutes.setting);
              } else if (index == 4) {
                Get.toNamed(AppRoutes.notify);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColours.bg,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage(iconss[index]), height: 40),
                          Gap(4),
                          Text(screens[index], style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

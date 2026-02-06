import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        children: [
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back_ios_new_outlined, size: 30),
                ),
              ),
              Gap(width * 0.35),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    (user["userimage"] != null &&
                            user["userimage"].toString().startsWith("http"))
                        ? user["userimage"].toString().replaceFirst(
                            "http://",
                            "https://",
                          )
                        : "", // Empty string agar image na ho
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,

                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(AppImages.user, fit: BoxFit.cover);
                    },
                    // Loading ke waqt placeholder
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                ),
              ),
              Gap(16),
              Column(
                children: [
                  Text(
                    user["name"],
                    style: TextStyle(fontSize: 22, letterSpacing: 2),
                  ),
                  Text("Beloved Panda Live User"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

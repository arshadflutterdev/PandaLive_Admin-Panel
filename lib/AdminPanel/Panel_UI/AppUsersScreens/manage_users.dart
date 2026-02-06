import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Buttons/my_elevatedbutton.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  //Function related block a user

  Future<void> blockappUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(userId)
          .update({"blockStatus": "blocked"});
      Get.back(); // Dialog band karne ke liye
      Get.snackbar(
        "Blocked",
        "User has been blocked successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      e.toString();
    }
  }

  void blockUser() {
    Get.defaultDialog(
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "This user will not be able to use the app after being blocked.",
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: "Are You Sure?",
      backgroundColor: Colors.red,
      titleStyle: TextStyle(color: Colors.white),
      confirm: TextButton(
        onPressed: () {
          final String? userrId = user["userId"];
          if (userrId != null && userrId.isNotEmpty) {
            blockappUser(userrId);
          } else {
            Get.snackbar(
              "Failed",
              "Failed to Block user",
              backgroundColor: Colors.blue,
              colorText: Colors.white,
            );
          }
        },
        child: Text(
          "Confirm",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }

  //function to delete user
  Future<void> deleteAuser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(userId)
          .delete();
      Get.back();
      Get.back();
      Get.snackbar(
        "Success",
        "User Deleted Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      e.toString();
    }
  }

  void deleteUser() {
    Get.defaultDialog(
      title: "Sure to Delete the User",
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("You Are About To Delete an Panda Live App User"),
      ),
      titleStyle: const TextStyle(fontSize: 20),
      backgroundColor: Colors.white,
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
      confirm: TextButton(
        onPressed: () {
          // Yahan 'uid' check karein
          final String? userId = user["userId"];

          if (userId != null && userId.isNotEmpty) {
            deleteAuser(userId); // Agar ID hai to delete function call hoga
          } else {
            // Agar ID nahi hai to hi ye snackbar chalna chahiye
            Get.snackbar(
              "Error",
              "User ID not found in data",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },

        child: const Text("Confirm", style: TextStyle(color: Colors.red)),
      ),
    );
  }

  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
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
          Gap(30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Country"),
                      Spacer(),
                      Text(user["country"].toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Week Earned Coins"),
                      Spacer(),

                      Text(
                        (user["coins"] != null)
                            ? user["coins"].toString()
                            : "0",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Week Earnings"), Spacer(), Text("45\$")],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,

                          "Total Withdrawl Ammount",
                        ),
                      ),
                      Spacer(),
                      Text("350\$"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Gender"),
                      Spacer(),
                      Text(user["gender"].toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Followers"),
                      Spacer(),
                      Text(
                        (user["totalFollowers"] != null)
                            ? user["totalFollowers"].toString()
                            : "0",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Follow"),
                      Spacer(),
                      Text(
                        (user["totalFollowing"] != null)
                            ? user["totalFollowing"].toString()
                            : "0",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.30,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Date Of Birth"),
                      Spacer(),
                      Text(user["dob"].toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: MyElevatedButton(
                  bcolor: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        "Delete User",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
                  onpressed: () {
                    deleteUser();
                  },
                ),
              ),
              Gap(20),
              SizedBox(
                height: 40,
                child: MyElevatedButton(
                  bcolor: Color(0xffCF0F0F),
                  child: Row(
                    children: [
                      Text(
                        "Block User",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(5),
                      Icon(Icons.block, color: Colors.white),
                    ],
                  ),
                  onpressed: () {
                    blockUser();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

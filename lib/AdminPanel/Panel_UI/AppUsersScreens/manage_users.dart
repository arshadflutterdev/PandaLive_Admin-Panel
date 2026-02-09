import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    bool isArabic = Get.locale?.languageCode == "ar";
    try {
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(userId)
          .update({"blockStatus": "blocked"});
      Get.back(); // Dialog band karne ke liye
      Get.snackbar(
        titleText: Text(isArabic ? "محظور" : "Blocked"),
        "",
        "",
        messageText: Text(
          isArabic
              ? "تم حظر المستخدم بنجاح"
              : "User has been blocked successfully",
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      e.toString();
    }
  }

  void blockUser() {
    bool isArabics = Get.locale?.languageCode == "ar";
    Get.defaultDialog(
      content: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          isArabics
              ? "لن يتمكن هذا المستخدم من استخدام التطبيق بعد حظره."
              : "This user will not be able to use the app after being blocked.",
          style: TextStyle(color: Colors.red),
        ),
      ),
      title: isArabics ? "Are You Sure?" : "هل أنت متأكد؟",
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.red),
      confirm: TextButton(
        onPressed: () {
          final String? userrId = user["userId"];
          if (userrId != null && userrId.isNotEmpty) {
            blockappUser(userrId);
            Get.back();
          } else {
            Get.snackbar(
              "",
              titleText: Text(isArabics ? "فشل" : "Failed"),
              "",
              messageText: Text(
                isArabics ? "فشل حظر المستخدم" : "Failed to Block user",
              ),
              backgroundColor: Colors.blue,
              colorText: Colors.white,
            );
          }
        },
        child: Text(
          isArabics ? "يتأكد" : "Confirm",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          isArabics ? "يلغي" : "Cancel",
          style: TextStyle(fontSize: 17, color: Colors.green),
        ),
      ),
    );
  }

  //function to delete user

  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(height * 0.050),
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
              Gap(width * 0.025),
              CircleAvatar(
                radius: 25,
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
                    style: TextStyle(fontSize: 18, letterSpacing: 2),
                  ),
                  Text(
                    "pandauser".tr,
                    style: isArabic
                        ? GoogleFonts.amiri(fontSize: 14)
                        : TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Gap(30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "country".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
                        Spacer(),
                        Text(user["country"].toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "weekcoins".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
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
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "weekearn".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
                        Spacer(),
                        Text("45\$"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,

                            "totalwid".tr,
                            style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                          ),
                        ),
                        Spacer(),
                        Text("350\$"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "gender".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
                        Spacer(),
                        Text(user["gender"].toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "follower".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
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
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "follow".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
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
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "dob".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
                        Spacer(),
                        Text(user["dob"].toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "block".tr,
                          style: isArabic ? GoogleFonts.amiri() : TextStyle(),
                        ),
                        Spacer(),
                        Text(
                          user["blockStatus"] ?? "${"normal".tr}".toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: MyElevatedButton(
                  bcolor: Color(0xffCF0F0F),
                  child: Row(
                    children: [
                      Text(
                        "blockusers".tr,
                        style: isArabic
                            ? GoogleFonts.amiri(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
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

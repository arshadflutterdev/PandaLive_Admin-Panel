import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Buttons/my_elevatedbutton.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({super.key});

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen>
    with SingleTickerProviderStateMixin {
  //Let's get the data of users from firebase

  TabController? tabController;

  late Stream<QuerySnapshot> userStream;
  late Stream<QuerySnapshot> blockUsers;
  @override
  void initState() {
    super.initState();
    //block users
    blockUsers = FirebaseFirestore.instance
        .collection("userProfile")
        .where("blockStatus", isEqualTo: "blocked")
        .snapshots();

    //all users
    userStream = FirebaseFirestore.instance
        .collection("userProfile")
        .snapshots();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        children: [
          Gap(height * 0.060),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              child: TabBar(
                // dividerColor: Colors.red,
                // indicatorColor: Colors.red,
                labelColor: Colors.white,
                controller: tabController,
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyle(color: Colors.black),

                tabs: [
                  Text(
                    "totaluser".tr,
                    style: isArabic
                        ? GoogleFonts.amiri()
                        : TextStyle(fontSize: 18),
                  ),
                  Text(
                    "blockuser".tr,
                    style: isArabic
                        ? GoogleFonts.amiri()
                        : TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                StreamBuilder(
                  stream: userStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("No User Found"));
                    } else {
                      if (snapshot.hasError) {
                        Center(
                          child: Text("Small Error Found We are Working on"),
                        );
                      }
                      final data = snapshot.data!.docs;
                      final filterData = data.where((doc) {
                        var d = doc.data() as Map<String, dynamic>;
                        return d["blockStatus"] != "blocked";
                      }).toList();
                      return ListView.builder(
                        itemCount: filterData.length,
                        itemBuilder: (context, index) {
                          var userdata =
                              filterData[index].data() as Map<String, dynamic>;
                          return Card(
                            color: Color(0xff0D1A63),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.network(
                                    (userdata["userimage"] != null &&
                                            userdata["userimage"]
                                                .toString()
                                                .startsWith("http"))
                                        ? userdata["userimage"]
                                              .toString()
                                              .replaceFirst(
                                                "http://",
                                                "https://",
                                              )
                                        : "", // Empty string agar image na ho
                                    fit: BoxFit.cover,

                                    // width: 30,
                                    // height: 30,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AppImages.user,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    // Loading ke waqt placeholder
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          );
                                        },
                                  ),
                                ),
                              ),

                              title: Text(
                                userdata["name"] ?? "no name",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "${"follow".tr} ${userdata["totalFollowing"] ?? "0".toString()}",
                                    style: isArabic
                                        ? GoogleFonts.amiri(color: Colors.white)
                                        : TextStyle(color: Colors.white),
                                  ),
                                  Gap(isArabic ? 8 : 3),
                                  Text(
                                    "${"follower".tr} ${userdata["totalFollowers"] ?? "0".toString()}",
                                    style: isArabic
                                        ? GoogleFonts.amiri(color: Colors.white)
                                        : TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.manage,
                                    arguments: userdata,
                                  );
                                },
                                child: Text(
                                  "manage".tr,
                                  style: isArabic
                                      ? GoogleFonts.amiri(
                                          color: Colors.white,
                                          fontSize: 20,
                                        )
                                      : TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                StreamBuilder(
                  stream: blockUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("noblockuser"));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error Found"));
                    }
                    final data = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var doc = data[index];
                        var userdata =
                            data[index].data() as Map<String, dynamic>;
                        return Card(
                          color: Color(0xff0D1A63),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.network(
                                  (userdata["userimage"] != null &&
                                          userdata["userimage"]
                                              .toString()
                                              .startsWith("http"))
                                      ? userdata["userimage"]
                                            .toString()
                                            .replaceFirst("http://", "https://")
                                      : "", // Empty string agar image na ho
                                  fit: BoxFit.cover,

                                  // width: 30,
                                  // height: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppImages.user,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  // Loading ke waqt placeholder
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                ),
                              ),
                            ),

                            title: Text(
                              userdata["name"] ?? "no name",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "${"follow".tr} ${userdata["totalFollowing"] ?? "0".toString()}",
                                  style: isArabic
                                      ? GoogleFonts.amiri(color: Colors.white)
                                      : TextStyle(color: Colors.white),
                                ),
                                Gap(isArabic ? 8 : 3),
                                Text(
                                  "${"follower".tr} ${userdata["totalFollowers"] ?? "0".toString()}",
                                  style: isArabic
                                      ? GoogleFonts.amiri(color: Colors.white)
                                      : TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection("userProfile")
                                      .doc(doc.id)
                                      .update({
                                        "blockStatus": FieldValue.delete(),
                                      });
                                  Get.snackbar(
                                    titleText: Text(
                                      isArabic ? "غير محظور" : "Unblocked",
                                    ),
                                    messageText: Text(
                                      isArabic
                                          ? "${userdata["name"]}أصبح الآن نشطًا مرة أخرى"
                                          : "${userdata["name"]} is now active again!",
                                    ),

                                    "",
                                    "",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green.withOpacity(
                                      0.8,
                                    ),
                                    colorText: Colors.white,
                                  );
                                } catch (e) {
                                  e.toString();
                                }
                              },
                              child: Text(
                                "unblock".tr,
                                style: isArabic
                                    ? GoogleFonts.amiri(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )
                                    : TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

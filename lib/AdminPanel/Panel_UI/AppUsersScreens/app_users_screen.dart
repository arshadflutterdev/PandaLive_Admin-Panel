import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Column(
        children: [
          Gap(5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              child: TabBar(
                // dividerColor: Colors.black,
                indicatorColor: Colors.red,
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
                  Text("Total App Users", style: TextStyle(fontSize: 18)),
                  Text("Blocked Users", style: TextStyle(fontSize: 18)),
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

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var userdata =
                              data[index].data() as Map<String, dynamic>;
                          return Card(
                            color: Color(0xff0D1A63),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
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
                                    width: 60,
                                    height: 60,

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
                                    "Follow ${userdata["totalFollowing"] ?? "0".toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Gap(10),
                                  Text(
                                    "Followers ${userdata["totalFollowers"] ?? "0".toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: SizedBox(
                                height: 45,
                                child: MyElevatedButton(
                                  bcolor: Colors.white,
                                  child: Text(
                                    "Manage",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onpressed: () {
                                    Get.toNamed(
                                      AppRoutes.manage,
                                      arguments: userdata,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                Center(child: Text("2sri tab ka data")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

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
          Gap(15),

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
                      return Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("No User Found"));
                    } else {
                      if (snapshot.hasError) {
                        Center(
                          child: Text("Small Error Found We are Working on"),
                        );
                      }
                      final data = snapshot.data;

                      return Text(data.toString());
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

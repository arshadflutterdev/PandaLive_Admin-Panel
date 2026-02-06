import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final liveStream = FirebaseFirestore.instance.collection("LiveStream");
  late DateTime stableThreshold;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    stableThreshold = DateTime.now().subtract(const Duration(minutes: 1));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColours.bg,

      body: StreamBuilder<QuerySnapshot>(
        stream: liveStream
            .where("uid", isNotEqualTo: currentUserId)
            .where("lastHeartbeat", isGreaterThan: stableThreshold)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return Text("Error in data");
          } else if (!snapshot.hasData) {
            return Center(child: Text("There is no data"));
          } else {
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Center(child: Text("No one Live NOw"));
            }
            return GridView.builder(
              itemCount: docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: kIsWeb ? 3 : 2,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                if (data.isEmpty) {}
                return GestureDetector(
                  onTap: () {
                    if (data["agoraUid"] == null) {
                      Get.snackbar(
                        "Wait",
                        "Host is still connecting...",
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    // Get.toNamed(
                    //   AppRoutes.watchstream,
                    //   arguments: {
                    //     "uid": data["uid"],
                    //     "channelId": data["channelId"],
                    //     "hostname": data["hostname"],
                    //     "hostphoto": data["image"],
                    //     "agoraUid":
                    //         data["agoraUid"], // This is the ID we saved in GoLiveScreen
                    //   },
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: data["image"] != null
                            ? NetworkImage(data["image"])
                            : Icon(Icons.image, color: Colors.black)
                                  as ImageProvider,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColours.bg,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("Live now"),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    data["hostname"] ?? "Guest",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              Gap(5),

                              Spacer(),
                              Icon(Icons.remove_red_eye, color: Colors.black),
                              Gap(3),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  (data["views"] ?? 0).toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

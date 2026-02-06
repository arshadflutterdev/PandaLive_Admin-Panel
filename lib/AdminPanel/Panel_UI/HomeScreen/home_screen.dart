import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
            return Text("There is no data");
          } else {
            return Obx(() {
              final docs = snapshot.data?.docs ?? [];
              final query = widget.searchText.value.toLowerCase();
              final filteredDocs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final hostname = (data["hostname"] ?? "")
                    .toString()
                    .toLowerCase();
                return hostname.contains(query);
              }).toList();

              print("here is docs list ${docs.length}");
              if (filteredDocs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_camera_front_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const Gap(10),
                      Text(
                        isArabic
                            ? "لا يوجد بث مباشر حالياً"
                            : "No one is live right now",
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                      Text(
                        isArabic ? "ابدأ بثك الخاص" : "Start your own stream",
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                itemCount: filteredDocs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final data =
                      filteredDocs[index].data() as Map<String, dynamic>;
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
                      Get.toNamed(
                        AppRoutes.watchstream,
                        arguments: {
                          "uid": data["uid"],
                          "channelId": data["channelId"],
                          "hostname": data["hostname"],
                          "hostphoto": data["image"],
                          "agoraUid":
                              data["agoraUid"], // This is the ID we saved in GoLiveScreen
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: data["image"] != null
                              ? NetworkImage(data["image"])
                              : AssetImage(AppImages.bgimage) as ImageProvider,
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
                                color: AppColours.greycolour,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(isArabic ? "عش الآن" : "Live now"),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data["hostname"] ?? "Guest",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: isArabic
                                        ? AppStyle.arabictext.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )
                                        : TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),

                                Gap(5),

                                Spacer(),
                                Icon(Icons.remove_red_eye, color: Colors.white),
                                Gap(3),
                                Text(
                                  (data["views"] ?? 0).toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
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
            });
          }
        },
      ),
    );
  }
}

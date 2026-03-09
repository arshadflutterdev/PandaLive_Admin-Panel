import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({super.key});

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  late Stream<QuerySnapshot> userStream;
  late Stream<QuerySnapshot> blockUsers;

  @override
  void initState() {
    super.initState();
    blockUsers = FirebaseFirestore.instance
        .collection("userProfile")
        .where("blockStatus", isEqualTo: "blocked")
        .snapshots();

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

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light BG like image
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP TABS (Real User / Block User) ---
            Container(
              width: 350,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: const Color(0xFF8E8FFA), // Purple theme from image
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs: [
                  Tab(text: "totaluser".tr),
                  Tab(text: "blockuser".tr),
                ],
              ),
            ),
            const Gap(20),

            // --- MAIN TABLE CONTAINER ---
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _buildUserTable(
                      userStream,
                      false,
                      isArabic,
                    ), // Active Users
                    _buildUserTable(
                      blockUsers,
                      true,
                      isArabic,
                    ), // Blocked Users
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTable(
    Stream<QuerySnapshot> stream,
    bool isBlockTab,
    bool isArabic,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF8E8FFA)),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(isBlockTab ? "noblockuser".tr : "No User Found"),
          );
        }

        final allDocs = snapshot.data!.docs;
        // Filter logic for active users tab
        final data = isBlockTab
            ? allDocs
            : allDocs
                  .where(
                    (doc) => (doc.data() as Map)["blockStatus"] != "blocked",
                  )
                  .toList();

        return Column(
          children: [
            // Table Header Row
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    isBlockTab ? "Blocked Users" : "Real User",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Search Box
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // The Data Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFFBFBFF),
                    ),
                    horizontalMargin: 20,
                    columnSpacing: 40,
                    columns: const [
                      DataColumn(label: Text('NO')),
                      DataColumn(label: Text('NAME')),
                      DataColumn(label: Text('GENDER')),
                      DataColumn(label: Text('BLOCK STATUS')),
                      DataColumn(label: Text('ACTION')),
                    ],
                    rows: data.asMap().entries.map((entry) {
                      int index = entry.key;
                      var doc = entry.value;
                      var userdata = doc.data() as Map<String, dynamic>;

                      return DataRow(
                        cells: [
                          DataCell(Text("${index + 1}")),
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF0F0F0),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      userdata["userimage"] ?? "",
                                      fit: BoxFit.cover,
                                      // Agar network image fail ho jaye to ye chalega
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 20,
                                              color: Colors.grey,
                                            );
                                          },
                                      // Jab tak image load ho rahi ho
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const Center(
                                              child: SizedBox(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Text(userdata["name"] ?? "no name"),
                              ],
                            ),
                          ),
                          DataCell(Text(userdata["gender"] ?? "Male")),
                          DataCell(
                            Switch(
                              value: userdata["blockStatus"] == "blocked",
                              activeColor: const Color(0xFF8E8FFA),
                              onChanged: (val) => _toggleBlockStatus(
                                doc.id,
                                val,
                                userdata["name"],
                              ),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () => Get.toNamed(
                                AppRoutes.manage,
                                arguments: userdata,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Logic to Block/Unblock
  void _toggleBlockStatus(String docId, bool block, String name) async {
    await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(docId)
        .update({"blockStatus": block ? "blocked" : FieldValue.delete()});

    Get.snackbar(
      block ? "Blocked" : "Unblocked",
      "$name status updated successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: block
          ? Colors.red.withOpacity(0.8)
          : Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}

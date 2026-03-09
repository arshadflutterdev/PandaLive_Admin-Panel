import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({super.key});

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  late Stream<QuerySnapshot> userStream;
  String searchText = "";
  Set<String> selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance
        .collection("userProfile")
        .snapshots();
    tabController = TabController(length: 3, vsync: this);
    // Tab change par selection clear karne ke liye
    tabController!.addListener(() {
      if (!tabController!.indexIsChanging) {
        setState(() => selectedUserIds.clear());
      }
    });
  }

  String _getFormattedDate(dynamic createdAt) {
    if (createdAt == null) return "N/A";
    DateTime dt;
    if (createdAt is Timestamp) {
      dt = createdAt.toDate();
    } else {
      return createdAt.toString();
    }
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  Future<void> _blockSelectedUsers() async {
    if (selectedUserIds.isEmpty) {
      Get.snackbar(
        "Notice",
        "Please select users first",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.defaultDialog(
      title: "Confirm Block",
      middleText:
          "Are you sure you want to block ${selectedUserIds.length} users?",
      textConfirm: "Confirm",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        for (String id in selectedUserIds) {
          DocumentReference ref = FirebaseFirestore.instance
              .collection("userProfile")
              .doc(id);
          batch.update(ref, {"blockStatus": "blocked"});
        }
        await batch.commit();
        setState(() => selectedUserIds.clear());
        Get.back();
        Get.snackbar(
          "Success",
          "Users blocked successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- PROFESSIONAL HEADER TABS ---
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blueGrey,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF6C63FF),
                  ),
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("All Users"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Verified Users"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Blocked Users"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),

            // --- TABLE CARD ---
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTopActionRow(),
                    const Divider(height: 1),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          _buildUserTable("all"),
                          _buildUserTable("verified"),
                          _buildUserTable("blocked"),
                        ],
                      ),
                    ),
                    _buildTableFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Text(
            "User Directory",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B3674),
            ),
          ),
          const Spacer(),
          // SEARCH
          Container(
            width: 280,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: (v) => setState(() => searchText = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: "Search name, ID...",
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.blueGrey,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const Gap(12),
          // BLOCK BUTTON
          ElevatedButton.icon(
            onPressed: _blockSelectedUsers,
            icon: const Icon(Icons.block, size: 16),
            label: const Text("Block Selected"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE5D50),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTable(String type) {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, snapshot) {
        // 1. Connection state aur error handling
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Data check
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;

          // Search Filter
          String name = data['name']?.toString().toLowerCase() ?? "";
          String sid = data['shortId']?.toString() ?? "";
          bool matchesSearch =
              name.contains(searchText) || sid.contains(searchText);

          if (!matchesSearch) return false;

          // Tab Filtering Logic
          if (type == "blocked") {
            return data['blockStatus'] == "blocked";
          } else if (type == "verified") {
            // 'isVerified' field ko boolean check karein (String error se bachne ke liye)
            return data['isVerified'] == true;
          }

          return true; // "all" tab ke liye
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(
            child: Text("No matching users in this category"),
          );
        }

        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 100,
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFF4F7FE).withOpacity(0.5),
                  ),
                  dataRowHeight: 75,
                  horizontalMargin: 20,
                  columns: _tableColumns(),
                  rows: filteredDocs.asMap().entries.map((entry) {
                    var doc = entry.value;
                    var data = doc.data() as Map<String, dynamic>;
                    return DataRow(
                      selected: selectedUserIds.contains(doc.id),
                      onSelectChanged: (val) {
                        setState(() {
                          val!
                              ? selectedUserIds.add(doc.id)
                              : selectedUserIds.remove(doc.id);
                        });
                      },
                      cells: [
                        DataCell(Text("${entry.key + 1}")),
                        DataCell(
                          _buildUserInfo(
                            data['userimage'],
                            data['name'],
                            data['userId'],
                            data['isVerified'],
                          ),
                        ),
                        DataCell(
                          _buildCopyableID(
                            data['shortId']?.toString() ?? "---",
                          ),
                        ),
                        DataCell(Text(data['gender'] ?? "N/A")),
                        DataCell(Text(data['country'] ?? "Global")),
                        DataCell(
                          Switch(
                            value: data['blockStatus'] == "blocked",
                            onChanged: (v) => _updateBlockStatus(doc.id, v),
                          ),
                        ),
                        // Yahan error tha: Timestamp ko String mein convert kiya
                        DataCell(Text(_getFormattedDate(data['createdAt']))),
                        DataCell(
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_note),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _tableColumns() {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFA3AED0),
      fontSize: 12,
    );
    return [
      const DataColumn(label: Text('NO', style: style)),
      const DataColumn(label: Text('USER PROFILE', style: style)),
      const DataColumn(label: Text('UNIQUE ID', style: style)),
      const DataColumn(label: Text('GENDER', style: style)),
      const DataColumn(label: Text('LOCATION', style: style)),
      const DataColumn(label: Text('RESTRICT', style: style)),
      const DataColumn(label: Text('JOINED', style: style)),
      const DataColumn(label: Text('ACTIONS', style: style)),
    ];
  }

  Widget _buildUserInfo(
    String? img,
    String? name,
    String? userId,
    bool? isVerified,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE0E5F2),
            backgroundImage: (img != null && img.isNotEmpty)
                ? NetworkImage(img)
                : null,
            child: (img == null || img.isEmpty)
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    name ?? "Guest User",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2559),
                    ),
                  ),
                  if (isVerified == true) ...[
                    const Gap(4),
                    const Icon(Icons.verified, size: 14, color: Colors.blue),
                  ],
                ],
              ),
              Text(
                "@${userId ?? 'unknown'}",
                style: const TextStyle(color: Color(0xFFA3AED0), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableID(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            id,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const Gap(4),
          const Icon(Icons.copy_rounded, size: 12, color: Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _buildTableFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF4F7FE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _pageBtn("<", false),
          _pageBtn("1", true),
          _pageBtn(">", false),
        ],
      ),
    );
  }

  Widget _pageBtn(String txt, bool active) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C63FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? Colors.transparent : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Text(
        txt,
        style: TextStyle(
          color: active ? Colors.white : Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _updateBlockStatus(String docId, bool isBlocked) async {
    await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(docId)
        .update({"blockStatus": isBlocked ? "blocked" : "active"});
  }
}

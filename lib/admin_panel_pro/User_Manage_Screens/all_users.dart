import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/admin_panel_pro/User_Manage_Screens/user_details.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({super.key});

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String searchText = "";
  Set<String> selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
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
        ],
      ),
    );
  }

  Widget _buildUserTable(String type) {
    return StreamBuilder<QuerySnapshot>(
      // Stream ko yahan direct call kiya hai taaki tab switch par refresh ho
      stream: FirebaseFirestore.instance.collection("userProfile").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var allDocs = snapshot.data?.docs ?? [];

        var filteredDocs = allDocs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          String name = (data['name'] ?? "").toString().toLowerCase();
          String sid = (data['shortId'] ?? "").toString();
          bool matchesSearch =
              name.contains(searchText) || sid.contains(searchText);

          if (!matchesSearch) return false;

          if (type == "blocked") return data['blockStatus'] == "blocked";
          if (type == "verified") return data['isVerified'] == true;
          return true;
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("No users found in this category"));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 100,
              ),
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFFF4F7FE).withOpacity(0.5),
                ),
                dataRowHeight: 75,
                columns: _tableColumns(),
                rows: filteredDocs.asMap().entries.map((entry) {
                  var doc = entry.value;
                  var data = doc.data() as Map<String, dynamic>;
                  return DataRow(
                    selected: selectedUserIds.contains(doc.id),
                    onSelectChanged: (val) => setState(
                      () => val!
                          ? selectedUserIds.add(doc.id)
                          : selectedUserIds.remove(doc.id),
                    ),
                    cells: [
                      // DataCell(Text("${entry.key + 1}")),
                      DataCell(
                        _buildUserInfo(
                          data['userimage'],
                          data['name'],
                          data['userId'],
                          data['isVerified'],
                        ),
                      ),
                      DataCell(
                        _buildCopyableID(data['shortId']?.toString() ?? "---"),
                      ),
                      DataCell(Text(data['gender'] ?? "N/A")),
                      DataCell(Text(data['country'] ?? "Global")),
                      DataCell(
                        Switch(
                          value: data['blockStatus'] == "blocked",
                          onChanged: (v) => _updateBlockStatus(doc.id, v),
                        ),
                      ),
                      DataCell(Text(_getFormattedDate(data['createdAt']))),
                      DataCell(
                        // AppUsersScreen ke andar IconButton update karein
                        IconButton(
                          onPressed: () {
                            Get.to(
                              () => UserPrewiew(userData: data, docId: doc.id),
                            );
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_sharp,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
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
      const DataColumn(label: Text('USER PROFILE', style: style)),
      const DataColumn(label: Text('UNIQUE ID', style: style)),
      const DataColumn(label: Text('GENDER', style: style)),
      const DataColumn(label: Text('LOCATION', style: style)),
      const DataColumn(label: Text('Block Status', style: style)),
      const DataColumn(label: Text('JOINED', style: style)),
      const DataColumn(label: Text('Preview', style: style)),
    ];
  }

  Widget _buildUserInfo(
    String? img,
    String? name,
    String? userId,
    bool? isVerified,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE0E5F2),
          child: ClipOval(
            child: (img != null && img.isNotEmpty)
                ? Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, color: Colors.grey),
                  )
                : const Icon(Icons.person, color: Colors.white),
          ),
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (isVerified == true) ...[
                  const Gap(4),
                  const Icon(Icons.verified, size: 14, color: Colors.blue),
                ],
              ],
            ),
            Text(
              "@${userId ?? 'unknown'}",
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCopyableID(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(id, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildTableFooter() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("End of List", style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _pageBtn(String txt, bool active) {
    return Container(); // Placeholder
  }

  Future<void> _updateBlockStatus(String docId, bool isBlocked) async {
    await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(docId)
        .update({"blockStatus": isBlocked ? "blocked" : "active"});
  }
}

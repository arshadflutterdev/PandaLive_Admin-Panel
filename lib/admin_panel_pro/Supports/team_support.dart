import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamSupport extends StatefulWidget {
  const TeamSupport({super.key});

  @override
  State<TeamSupport> createState() => _TeamSupportState();
}

class _TeamSupportState extends State<TeamSupport>
    with TickerProviderStateMixin {
  late TabController tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F4F9),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTabBar(),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTableToolbar(),
                    _buildTableHeader(),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          _buildSupportList(
                            "pending",
                          ), // Lowercase match with Firebase
                          _buildSupportList("solved"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportList(String statusFilter) {
    return StreamBuilder<QuerySnapshot>(
      // FIXED: Sub-collection ko access karne ke liye collectionGroup use kiya hai
      stream: _firestore
          .collectionGroup("help_requests")
          .where("status", isEqualTo: statusFilter)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Agar indexing ka masla ho to yahan error nazar ayega
          return Center(child: Text("Firebase Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff7C78FF)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 50, color: Colors.grey),
                const SizedBox(height: 10),
                Text("No '$statusFilter' requests found in sub-collections."),
              ],
            ),
          );
        }

        var docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade100),
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;

            // Database mapping as per screenshot
            String userName = data['userName'] ?? "No Name";
            String topic = data['topic'] ?? "No Topic";
            String detail = data['detail'] ?? "No Detail";
            String shortId = data['shortId']?.toString() ?? "N/A";

            String dateStr = "N/A";
            String timeStr = "N/A";
            if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
              DateTime dt = (data['createdAt'] as Timestamp).toDate();
              dateStr = DateFormat('dd/MM/yyyy').format(dt);
              timeStr = DateFormat('hh:mm a').format(dt);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                children: [
                  _cell("${index + 1}", 1),
                  _cell(shortId, 2),
                  Expanded(
                    flex: 3,
                    child: Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _cell(dateStr, 2),
                  _cell(timeStr, 2),
                  // INFO (Details popup)
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () => _showDetailPopup(topic, detail),
                    ),
                  ),
                  // ACTION (Status update)
                  Expanded(
                    flex: 2,
                    child: statusFilter == "pending"
                        ? IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 22,
                            ),
                            onPressed: () =>
                                _markAsSolved(docs[index].reference),
                          )
                        : const Icon(
                            Icons.done_all,
                            color: Colors.blue,
                            size: 20,
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- UI Layout Helpers ---
  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          _cell("NO", 1, isHeader: true),
          _cell("UNIQUE ID", 2, isHeader: true),
          _cell("NAME", 3, isHeader: true),
          _cell("DATE", 2, isHeader: true),
          _cell("TIME", 2, isHeader: true),
          _cell("INFO", 1, isHeader: true),
          _cell("ACTION", 2, isHeader: true),
        ],
      ),
    );
  }

  static Widget _cell(String text, int flex, {bool isHeader = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.grey.shade600 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: const Color(0xff7C78FF),
          borderRadius: BorderRadius.circular(6),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "Solved"),
        ],
      ),
    );
  }

  Widget _buildTableToolbar() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        "Support Request Table",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDetailPopup(String topic, String detail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(topic, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(detail),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _markAsSolved(DocumentReference ref) {
    ref.update({"status": "solved"});
  }
}

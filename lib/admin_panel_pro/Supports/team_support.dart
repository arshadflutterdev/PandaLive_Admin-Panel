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
                          _buildSupportList("pending"),
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
      stream: _firestore
          .collection("help_requests")
          .where("status", isEqualTo: statusFilter)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs;

        if (docs.isEmpty)
          return Center(child: Text("No $statusFilter requests found."));

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade100),
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            DateTime dateTime = (data['createdAt'] as Timestamp).toDate();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                children: [
                  _cell("${index + 1}", 1),
                  // NAME & SHORT ID
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['userName'] ?? "User",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "ID: ${data['shortId'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _cell(data['topic'] ?? "General", 2),
                  _cell(
                    data['detail'] ?? "No details provided",
                    3,
                  ), // Detail column
                  _cell(DateFormat('dd/MM/yyyy').format(dateTime), 2),
                  _cell(DateFormat('hh:mm a').format(dateTime), 2),
                  // ACTIONS
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        _actionButton(
                          Icons.check_circle_outline,
                          Colors.green,
                          () => _markAsSolved(docs[index].id),
                        ),
                        const SizedBox(width: 8),
                        _actionButton(
                          Icons.delete_outline,
                          Colors.red,
                          () => _deleteRequest(docs[index].id),
                        ),
                      ],
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

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          _cell("NO", 1, isHeader: true),
          _cell("USER NAME", 3, isHeader: true),
          _cell("TOPIC", 2, isHeader: true),
          _cell("DETAIL", 3, isHeader: true),
          _cell("DATE", 2, isHeader: true),
          _cell("TIME", 2, isHeader: true),
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
        maxLines: 1,
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

  void _markAsSolved(String id) {
    _firestore.collection("help_requests").doc(id).update({"status": "solved"});
  }

  void _deleteRequest(String id) {
    _firestore.collection("help_requests").doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawalScreens extends StatefulWidget {
  const WithdrawalScreens({super.key});

  @override
  State<WithdrawalScreens> createState() => _WithdrawalScreensState();
}

class _WithdrawalScreensState extends State<WithdrawalScreens>
    with TickerProviderStateMixin {
  late TabController tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Screen width check karne ke liye
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xffF1F4F9),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTabBar(isMobile),
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
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    _buildTableToolbar(isMobile),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          // Mobile par table ko width denge taaki columns cut na ho, desktop par full width
                          width: isMobile
                              ? 900
                              : screenWidth - (isMobile ? 24 : 50),
                          child: Column(
                            children: [
                              _buildTableHeader(),
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    _buildFirebaseDataTable(
                                      "Pending",
                                      isMobile,
                                    ),
                                    _buildFirebaseDataTable(
                                      "Approved",
                                      isMobile,
                                    ),
                                    _buildFirebaseDataTable(
                                      "Rejected",
                                      isMobile,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildFirebaseDataTable(String statusFilter, bool isMobile) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("userProfile")
          .where("withdrawlstatus", isEqualTo: statusFilter)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff7C78FF)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            alignment: isMobile ? Alignment.topLeft : Alignment.center,
            padding: const EdgeInsets.all(40),
            child: Text(
              "No $statusFilter requests found.",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }

        var docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade100),
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            String name = data['name'] ?? "No Name";
            String binanceId = data['binanceId'] ?? "N/A";
            var dollars = data['dollars'] ?? 0;
            String status = data['withdrawlstatus'] ?? "Pending";

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                children: [
                  _cell("${index + 1}", 1),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: data['userimage'] != null
                              ? NetworkImage(data['userimage'])
                              : null,
                          backgroundColor: const Color(
                            0xff7C78FF,
                          ).withOpacity(0.1),
                          child: data['userimage'] == null
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text("Binance", style: TextStyle(fontSize: 13)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            binanceId,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 14,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: binanceId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("ID Copied")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "\$ $dollars",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text("3/15/2026", style: TextStyle(fontSize: 12)),
                  ),
                  Expanded(flex: 2, child: _buildStatusBadge(status)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          _cell("NO", 1, isHeader: true),
          _cell("USERNAME", 3, isHeader: true),
          _cell("GATEWAY", 2, isHeader: true),
          _cell("GATEWAY ID", 2, isHeader: true),
          _cell("DOLLARS", 2, isHeader: true),
          _cell("DATE", 2, isHeader: true),
          _cell("STATUS", 2, isHeader: true),
        ],
      ),
    );
  }

  static Widget _cell(String text, int flex, {bool isHeader = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.grey.shade600 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == "Approved"
        ? Colors.green
        : (status == "Rejected" ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCustomTabBar(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 350,
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
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "Accepted"),
          Tab(text: "Declined"),
        ],
      ),
    );
  }

  Widget _buildTableToolbar(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Withdrawal Requests",
          textAlign: isMobile ? TextAlign.left : TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

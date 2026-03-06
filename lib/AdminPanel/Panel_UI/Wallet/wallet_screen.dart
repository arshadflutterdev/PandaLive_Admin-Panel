import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  // --- REJECT & REFUND LOGIC ---
  void _handleReject(String uid, String statusString) {
    // String se amount nikalna (e.g. "Pending ($50)" -> 50)
    int refundAmount = 0;
    try {
      if (statusString.contains("\$")) {
        refundAmount = int.parse(statusString.split("\$")[1].split(")")[0]);
      }
    } catch (e) {
      refundAmount = 0;
    }

    // Professional Confirmation Dialog
    Get.defaultDialog(
      title: "Confirm Rejection",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      middleText:
          "Are you sure you want to reject this request? \$$refundAmount will be refunded to the user's wallet.",
      textConfirm: "Confirm Reject",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back(); // Close Dialog
        _processRefund(uid, refundAmount);
      },
    );
  }

  // Database Transaction for Safety
  Future<void> _processRefund(String uid, int amount) async {
    DocumentReference userRef = _firestore.collection("userProfile").doc(uid);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        if (!snapshot.exists) return;

        int currentBalance = snapshot['dollars'] ?? 0;

        transaction.update(userRef, {
          "withdrawlstatus": "Rejected",
          "dollars": currentBalance + amount, // Refund added back
        });
      });
      Get.snackbar(
        "Rejected",
        "Request declined and \$$amount refunded.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to process refund: $e");
    }
  }

  // --- APPROVE LOGIC ---
  Future<void> _handleApprove(String uid) async {
    try {
      await _firestore.collection("userProfile").doc(uid).update({
        "withdrawlstatus": "Approved",
      });
      Get.snackbar(
        "Approved",
        "Withdrawal request marked as completed.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to approve: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA), // Professional Light Grey BG
      appBar: AppBar(
        title: const Text(
          "Withdrawal Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColours.bg,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 50,
            child: TabBar(
              controller: tabController,
              unselectedLabelColor: Colors.grey,
              labelColor: const Color(0xff0D1A63),
              indicatorColor: const Color(0xff0D1A63),
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  child: Text(
                    "Requests",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Approved",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Rejected",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildList("Pending"),
                _buildList("Approved"),
                _buildList("Rejected"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(String filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("userProfile").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return const Center(child: Text("Something went wrong"));
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        // Filter users who have withdrawal data
        var docs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          if (!data.containsKey('withdrawlstatus') ||
              data['withdrawlstatus'] == null)
            return false;
          return data['withdrawlstatus'].toString().contains(filter);
        }).toList();

        if (docs.isEmpty)
          return Center(child: Text("No $filter withdrawals found."));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            String uid = docs[index].id;
            String status = data['withdrawlstatus'].toString();

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['name'] ?? "Unknown User",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: filter == "Pending"
                              ? Colors.orange.withOpacity(0.1)
                              : (filter == "Approved"
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: filter == "Pending"
                                ? Colors.orange
                                : (filter == "Approved"
                                      ? Colors.green
                                      : Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 25),
                  Text(
                    "Binance Name: ${data['binanceName'] ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Binance ID: ${data['binanceId'] ?? 'N/A'}",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (filter == "Pending") ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () => _handleReject(uid, status),
                            child: const Text("Reject & Refund"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0D1A63),
                            ),
                            onPressed: () => _handleApprove(uid),
                            child: const Text(
                              "Approve Pay",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  // --- NOTIFICATION LOGIC ---
  Future<void> sendNotification(String uid, String title, String body) async {
    await _firestore
        .collection("userProfile")
        .doc(uid)
        .collection("notifications")
        .add({
          "title": title,
          "body": body,
          "time": FieldValue.serverTimestamp(),
          "isRead": false,
        });
  }

  // --- REJECT & REFUND LOGIC ---
  void _handleReject(String uid, String statusString, String userName) {
    int refundAmount = 0;
    try {
      if (statusString.contains("\$")) {
        refundAmount = int.parse(statusString.split("\$")[1].split(")")[0]);
      }
    } catch (e) {
      refundAmount = 0;
    }

    Get.defaultDialog(
      title: "Confirm Reject",
      middleText: "Reject request and refund \$$refundAmount to $userName?",
      textConfirm: "Confirm",
      textCancel: "Back",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        await _processRefund(uid, refundAmount, userName);
      },
    );
  }

  Future<void> _processRefund(String uid, int amount, String userName) async {
    DocumentReference userRef = _firestore.collection("userProfile").doc(uid);
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        int currentBalance = snapshot['dollars'] ?? 0;
        transaction.update(userRef, {
          "withdrawlstatus": "Rejected",
          "dollars": currentBalance + amount,
        });
      });
      // User ko notify karein
      await sendNotification(
        uid,
        "Withdrawal Rejected",
        "Sorry $userName, your request for \$$amount was rejected. Balance refunded.",
      );
      Get.snackbar("Rejected", "User notified & amount refunded.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // --- APPROVE LOGIC ---
  Future<void> _handleApprove(
    String uid,
    String userName,
    String statusString,
  ) async {
    try {
      await _firestore.collection("userProfile").doc(uid).update({
        "withdrawlstatus": "Approved",
      });
      // User ko notify karein
      await sendNotification(
        uid,
        "Congratulations! 🎉",
        "Hi $userName, your withdrawal request $statusString has been approved successfully.",
      );
      Get.snackbar(
        "Success",
        "Request Approved & User Notified",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text(
          "Admin Wallet",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff0D1A63),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            labelColor: const Color(0xff0D1A63),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xff0D1A63),
            tabs: const [
              Tab(text: "Requests"),
              Tab(text: "Approved"),
              Tab(text: "Rejected"),
            ],
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
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return data.containsKey('withdrawlstatus') &&
              data['withdrawlstatus'].toString().contains(filter);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            String uid = docs[index].id;
            String status = data['withdrawlstatus'].toString();
            String binanceId = data['binanceId'] ?? 'N/A';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'] ?? "User",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          status,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text("Binance Name: ${data['binanceName'] ?? 'N/A'}"),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "ID: $binanceId",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 20,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: binanceId));
                            Get.rawSnackbar(message: "Binance ID Copied!");
                          },
                        ),
                      ],
                    ),
                    if (filter == "Pending") ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () => _handleReject(
                                uid,
                                status,
                                data['name'] ?? "User",
                              ),
                              child: const Text(
                                "Reject",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () => _handleApprove(
                                uid,
                                data['name'] ?? "User",
                                status,
                              ),
                              child: const Text(
                                "Approve",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

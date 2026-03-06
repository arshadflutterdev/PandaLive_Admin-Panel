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

  // --- NOTIFICATION HELPER ---
  Future<void> sendNotification(
    String uid,
    String title,
    String body, {
    String? details,
  }) async {
    await _firestore
        .collection("userProfile")
        .doc(uid)
        .collection("notifications")
        .add({
          "title": title,
          "body": body,
          "paymentDetails": details ?? "",
          "time": FieldValue.serverTimestamp(),
          "isRead": false,
        });
  }

  // --- APPROVE LOGIC ---
  Future<void> _handleApprove(String uid, String userName) async {
    try {
      await _firestore.collection("userProfile").doc(uid).update({
        "withdrawlstatus": "Approved",
      });
      await sendNotification(
        uid,
        "Request Approved! 🎉",
        "Dear $userName, your withdrawal is approved. You will receive your payment within 3 working days.",
      );
      Get.snackbar(
        "Success",
        "Approved. User notified (3-day timeline).",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // --- PAYMENT DONE DIALOG ---
  void _showPaymentDoneDialog(String uid, String userName) {
    TextEditingController detailController = TextEditingController();
    Get.defaultDialog(
      title: "Confirm Payment",
      content: TextField(
        controller: detailController,
        decoration: const InputDecoration(
          hintText: "Enter Transaction ID / Details",
          border: OutlineInputBorder(),
        ),
      ),
      textConfirm: "Send Confirmation",
      onConfirm: () async {
        if (detailController.text.isEmpty) return;
        Get.back();
        await _firestore.collection("userProfile").doc(uid).update({
          "withdrawlstatus": "Payment Sent ✅",
        });
        await sendNotification(
          uid,
          "Payment Sent! 💵",
          "Congratulations! Your payment has been sent. Check details below.",
          details: detailController.text,
        );
        Get.snackbar("Sent", "Payment confirmation sent to $userName");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text("Withdrawal Management"),
        backgroundColor: const Color(0xff0D1A63),
        centerTitle: true,
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
            String name = data['name'] ?? "User";
            String country = data['country'] ?? "N/A"; // User ki country

            // Status string se Amount nikalna (e.g. "Pending ($50)" -> "$50")
            String displayAmount = "0";
            if (status.contains("\$")) {
              displayAmount = status.split("(")[1].split(")")[0];
            }

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
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            displayAmount,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Country: $country",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 25),
                    Text("Binance Name: ${data['binanceName'] ?? 'N/A'}"),
                    Row(
                      children: [
                        Text(
                          "Binance ID: $binanceId",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 18,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: binanceId));
                            Get.snackbar("Copied", "Binance ID copied");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (filter == "Pending") ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {}, // Aapka Reject Logic
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
                              onPressed: () => _handleApprove(uid, name),
                              child: const Text(
                                "Approve",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (filter == "Approved" &&
                        !status.contains("Payment Sent")) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0D1A63),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () => _showPaymentDoneDialog(uid, name),
                          label: const Text(
                            "Send Payment Details",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  // --- Methods Definitions ---

  Future<void> _handleApprove(String uid, String userName) async {
    try {
      await _firestore.collection("userProfile").doc(uid).update({
        "withdrawlstatus": "Approved", //
      });

      await _firestore
          .collection("userProfile")
          .doc(uid)
          .collection("notifications")
          .add({
            "title": "Request Approved! 🎉",
            "body":
                "Dear $userName, your withdrawal is approved. You will receive payment within 3 working days.",
            "time": FieldValue.serverTimestamp(),
          });

      Get.snackbar("Approved", "User $userName notified successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to approve: $e");
    }
  }

  void _handleReject(String uid, String statusString, String userName) {
    // Logic to extract amount if stored in string status like "Pending ($50)"
    int amount = 0;
    if (statusString.contains("\$")) {
      amount = int.tryParse(statusString.split("\$")[1].split(")")[0]) ?? 0;
    }

    Get.defaultDialog(
      title: "Confirm Reject",
      middleText: "Are you sure? \$$amount will be returned to $userName.",
      textConfirm: "Reject & Refund",
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          await _firestore.runTransaction((transaction) async {
            DocumentSnapshot snap = await transaction.get(
              _firestore.collection("userProfile").doc(uid),
            );
            transaction.update(_firestore.collection("userProfile").doc(uid), {
              "withdrawlstatus": "Rejected", //
              "dollars": (snap['dollars'] ?? 0) + amount,
            });
          });

          await _firestore
              .collection("userProfile")
              .doc(uid)
              .collection("notifications")
              .add({
                "title": "Withdrawal Rejected",
                "body":
                    "Dear $userName, your withdrawal request was rejected. Your balance has been refunded.",
                "time": FieldValue.serverTimestamp(),
              });
        } catch (e) {
          Get.snackbar("Error", "Transaction failed: $e");
        }
      },
    );
  }

  // --- UI Parts ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F4F9),
      appBar: AppBar(
        title: const Text(
          "Panda admin",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.grey),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xffD6E4FF),
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderTabs(),
          const SizedBox(height: 20),
          _buildTableContainer(),
        ],
      ),
    );
  }

  Widget _buildHeaderTabs() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Withdrawal Management",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xffF8F9FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: const Color(0xff7C78FF),
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Pending"),
                Tab(text: "Accepted"),
                Tab(text: "Declined"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    "Pending Withdraw Request",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  _buildSearchBox(),
                ],
              ),
            ),
            _buildTableHeader(),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _buildDataTable("Pending"),
                  _buildDataTable("Approved"),
                  _buildDataTable("Rejected"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "NO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "USERNAME",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "UNIQUE ID",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "COIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "DATE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "ACTION",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(String filter) {
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

        if (docs.isEmpty) return const Center(child: Text("No data found"));

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            String uid = docs[index].id;
            String status = data['withdrawlstatus'].toString();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text("${index + 1}")),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          child: Icon(Icons.person, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data['name'] ?? "User",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      uid.substring(0, 6),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.orange,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${data['coins'] ?? 100}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "9/26/2025",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: filter == "Pending"
                        ? Row(
                            children: [
                              _actionIconButton(
                                Icons.check,
                                Colors.green,
                                () => _handleApprove(uid, data['name']),
                              ),
                              const SizedBox(width: 10),
                              _actionIconButton(
                                Icons.close,
                                Colors.red,
                                () => _handleReject(uid, status, data['name']),
                              ),
                            ],
                          )
                        : Text(
                            filter,
                            style: TextStyle(
                              color: filter == "Approved"
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12,
                            ),
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

  Widget _actionIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 200,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search Here",
          hintStyle: TextStyle(fontSize: 12),
          prefixIcon: Icon(Icons.search, size: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 12),
        ),
      ),
    );
  }
}

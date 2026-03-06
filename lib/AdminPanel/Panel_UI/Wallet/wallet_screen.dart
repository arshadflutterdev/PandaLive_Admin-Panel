import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  // --- REJECT & REFUND ---
  void _handleReject(String uid, String statusString, String userName) {
    int amount = 0;
    if (statusString.contains("\$"))
      amount = int.tryParse(statusString.split("\$")[1].split(")")[0]) ?? 0;

    Get.defaultDialog(
      title: "Confirm Reject",
      middleText: "Are you sure? \$$amount will be returned to $userName.",
      textConfirm: "Reject & Refund",
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(
            _firestore.collection("userProfile").doc(uid),
          );
          transaction.update(_firestore.collection("userProfile").doc(uid), {
            "withdrawlstatus": "Rejected",
            "dollars": (snap['dollars'] ?? 0) + amount,
          });
        });
        // Notify User
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
      },
    );
  }

  // --- APPROVE ---
  Future<void> _handleApprove(String uid, String userName) async {
    await _firestore.collection("userProfile").doc(uid).update({
      "withdrawlstatus": "Approved",
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
    Get.snackbar("Approved", "User notified: 3 working days timeline.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
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
            String amount = status.contains("\$")
                ? status.split("(")[1].split(")")[0]
                : "0";

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
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          amount,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Country: ${data['country'] ?? 'N/A'}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Divider(height: 20),
                    Text("Binance ID: ${data['binanceId'] ?? 'N/A'}"),
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            color: status.contains("✅")
                                ? Colors.blue
                                : Colors.blueGrey,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 18,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: data['binanceId'] ?? ""),
                            );
                            Get.snackbar("Copied", "ID Copied");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (filter == "Pending")
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _handleReject(uid, status, data['name']),
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
                              onPressed: () =>
                                  _handleApprove(uid, data['name']),
                              child: const Text(
                                "Approve",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (filter == "Approved")
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0D1A63),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () => Get.to(
                            () => SendPaymentDetailsScreen(
                              uid: uid,
                              userName: data['name'],
                            ),
                          ),
                          label: Text(
                            status.contains("Sent")
                                ? "Update Payment Proof"
                                : "Send Payment Proof",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
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

class SendPaymentDetailsScreen extends StatefulWidget {
  final String uid;
  final String userName;

  const SendPaymentDetailsScreen({
    super.key,
    required this.uid,
    required this.userName,
  });

  @override
  State<SendPaymentDetailsScreen> createState() =>
      _SendPaymentDetailsScreenState();
}

class _SendPaymentDetailsScreenState extends State<SendPaymentDetailsScreen> {
  final TextEditingController _detailsController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _submitPayment() async {
    if (_detailsController.text.isEmpty && _selectedImage == null) {
      Get.snackbar("Error", "Please add details or a screenshot");
      return;
    }
    setState(() => _isLoading = true);
    try {
      String imageUrl = "";
      if (_selectedImage != null) {
        var snapshot = await FirebaseStorage.instance
            .ref(
              'payment_proofs/${widget.uid}_${DateTime.now().millisecondsSinceEpoch}',
            )
            .putFile(_selectedImage!);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Update status but keep in Approved list
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.uid)
          .update({
            "withdrawlstatus": "Payment Sent ✅",
            "paymentScreenshot": imageUrl,
            "paymentNote": _detailsController.text,
          });

      // Send Notification with Title & Subtitle
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.uid)
          .collection("notifications")
          .add({
            "title": "Payment Sent! 💵",
            "body":
                "Congratulations ${widget.userName}! Your payment has been processed. Check the screenshot and details.",
            "image": imageUrl,
            "details": _detailsController.text,
            "time": FieldValue.serverTimestamp(),
          });

      Get.back();
      Get.snackbar(
        "Success",
        "Payment proof sent to ${widget.userName}",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to upload: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Payment: ${widget.userName}"),
        backgroundColor: const Color(0xff0D1A63),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _selectedImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 50),
                          Text("Tap to upload Screenshot"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_selectedImage!, fit: BoxFit.contain),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Enter Transaction ID or Payment Notes...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D1A63),
                ),
                onPressed: _isLoading ? null : _submitPayment,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Confirm & Send Proof",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

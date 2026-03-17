import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AllowLiveUser extends StatefulWidget {
  const AllowLiveUser({super.key});

  @override
  State<AllowLiveUser> createState() => _AllowLiveUserState();
}

class _AllowLiveUserState extends State<AllowLiveUser> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Helper for UI Feedback
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Action: Approve
  Future<void> _handleApproval(String uid) async {
    try {
      WriteBatch batch = _db.batch();
      batch.update(_db.collection("userProfile").doc(uid), {
        "isVerified": "approved",
      });
      batch.update(
        _db
            .collection("userProfile")
            .doc(uid)
            .collection("isUserValid")
            .doc("verification_details"),
        {"status": "approved"},
      );
      await batch.commit();
      if (mounted) Navigator.pop(context);
      _showSnackBar("User has been verified successfully!", Colors.green);
    } catch (e) {
      _showSnackBar("Approval failed: $e", Colors.red);
    }
  }

  // Action: Reject
  Future<void> _handleRejection(String uid) async {
    try {
      await _db
          .collection("userProfile")
          .doc(uid)
          .collection("isUserValid")
          .doc("verification_details")
          .delete();
      await _db.collection("userProfile").doc(uid).update({
        "isVerified": "rejected",
      });
      if (mounted) Navigator.pop(context);
      _showSnackBar("Request rejected and data purged.", Colors.orange);
    } catch (e) {
      _showSnackBar("Rejection failed: $e", Colors.red);
    }
  }

  // Detailed Review Modal
  void _openReviewModal(String uid, Map<String, dynamic> user) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: _db
              .collection("userProfile")
              .doc(uid)
              .collection("isUserValid")
              .doc("verification_details")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());

            var docData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                // Top Indicator
                const Gap(10),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // User Basic Info Header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              user['userimage'] ?? "",
                            ),
                            backgroundColor: Colors.grey[200],
                          ),
                          const Gap(15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? "N/A",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "ID: ${user['shortId']}",
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),

                      // Detailed Info Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile(
                            "Country",
                            user['country'] ?? "N/A",
                            Icons.public,
                          ),
                          _infoTile(
                            "Gender",
                            user['gender'] ?? "N/A",
                            Icons.person_outline,
                          ),
                          _infoTile(
                            "D.O.B",
                            user['dob'] ?? "N/A",
                            Icons.cake_outlined,
                          ),
                        ],
                      ),
                      const Gap(25),

                      // Document Images
                      _buildImageSection(
                        "ID Card Front Side",
                        docData['idCardFront'],
                      ),
                      const Gap(20),
                      _buildImageSection(
                        "Live Face Selfie",
                        docData['facePic'],
                      ),
                      const Gap(100), // Space for buttons
                    ],
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => _handleRejection(uid),
                          style: TextButton.styleFrom(
                            fixedSize: Size.fromHeight(55),
                            foregroundColor: Colors.red,
                          ),
                          child: const Text(
                            "REJECT",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleApproval(uid),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "APPROVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const Gap(5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImageSection(String title, String? base64Str) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Gap(10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: base64Str != null
                ? Image.memory(
                    base64Decode(base64Str),
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                  )
                : const SizedBox(
                    height: 150,
                    child: Center(child: Text("Image Missing")),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Verification Desk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('userProfile')
            .where('isVerified', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const Gap(10),
                  const Text(
                    "No pending verification requests.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userDoc = snapshot.data!.docs[index];
              var userData = userDoc.data() as Map<String, dynamic>;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Hero(
                    tag: userDoc.id,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        userData['userimage'] ?? "",
                      ),
                    ),
                  ),
                  title: Text(
                    userData['name'] ?? "Anonymous",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${userData['gender']} • ${userData['country']}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _openReviewModal(userDoc.id, userData),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

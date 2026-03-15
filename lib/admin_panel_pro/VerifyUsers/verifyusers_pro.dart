import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyUsersPro extends StatefulWidget {
  const VerifyUsersPro({super.key});

  @override
  State<VerifyUsersPro> createState() => _VerifyUsersProState();
}

class _VerifyUsersProState extends State<VerifyUsersPro> {
  // 1. DECLINE: Request permanent delete ho jayegi
  Future<void> _declineRequest(String userId, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('verification_requests')
          .doc(requestId)
          .delete();
      _showStatus("Request Declined & Removed");
    } catch (e) {
      _showStatus("Error: $e");
    }
  }

  // 2. APPROVE: Blue Tick milega aur status 'approved' ho jayega (delete nahi hogi)
  Future<void> _approveRequest(String userId, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .update({'isVerified': true});

      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('verification_requests')
          .doc(requestId)
          .update({'mediaUrls.status': 'approved'});

      _showStatus("User Verified Successfully!");
    } catch (e) {
      _showStatus("Error: $e");
    }
  }

  // 3. REMOVE TICK: Blue tick wapis lena aur status pending karna
  Future<void> _removeBlueTick(String userId, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .update({'isVerified': false});

      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('verification_requests')
          .doc(requestId)
          .update({'mediaUrls.status': 'pending'});

      _showStatus("Blue Tick Removed");
    } catch (e) {
      _showStatus("Error: $e");
    }
  }

  void _showStatus(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          "Verification Requests",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('verification_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No requests found",
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1200
                  ? 3
                  : (constraints.maxWidth > 800 ? 2 : 1);
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 240,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var requestData = docs[index].data() as Map<String, dynamic>;
                  String userId = docs[index].reference.parent.parent!.id;
                  String requestId = docs[index].id;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('userProfile')
                        .doc(userId)
                        .get(),
                    builder: (context, userSnap) {
                      if (!userSnap.hasData) return const SizedBox();
                      var user = userSnap.data!.data() as Map<String, dynamic>;
                      bool isVerified = user['isVerified'] ?? false;
                      String currentStatus =
                          requestData['mediaUrls']?['status'] ?? "pending";

                      return _buildRequestCard(
                        user,
                        currentStatus,
                        userId,
                        requestId,
                        isVerified,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(
    Map<String, dynamic> user,
    String status,
    String uId,
    String rId,
    bool isVerified,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user['userimage'] ?? ""),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user['name'] ?? "User",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) const Gap(4),
                        if (isVerified)
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 16,
                          ),
                      ],
                    ),
                    Text(
                      "@${user['userId'] ?? 'id'}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              _statusBadge(status),
            ],
          ),
          const Gap(15),
          const Divider(),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoRow(Icons.public, user['country'] ?? "N/A"),
              _infoRow(
                Icons.history,
                isVerified ? "Verified User" : "New Request",
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _declineRequest(uId, rId),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Decline",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => isVerified
                      ? _removeBlueTick(uId, rId)
                      : _approveRequest(uId, rId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerified
                        ? Colors.orange
                        : const Color(0xFF4318FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isVerified ? "Remove Tick" : "Approve",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color badgeColor = status == "approved" ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const Gap(5),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

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
  // Action: Decline (Request ko delete karne ke liye)
  Future<void> _declineRequest(String userId, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('verification_requests')
          .doc(requestId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request Declined & Deleted")),
        );
      }
    } catch (e) {
      print("Error deleting request: $e");
    }
  }

  // Action: Approve (Blue Tick add karne ke liye)
  Future<void> _approveRequest(String userId, String requestId) async {
    try {
      // 1. User profile mein verified status true karein
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .update({'isVerified': true});

      // 2. Request ko delete kar dein kyunke kaam ho gaya
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('verification_requests')
          .doc(requestId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User Verified Successfully!")),
        );
      }
    } catch (e) {
      print("Error approving request: $e");
    }
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const Gap(10),
                  Text(
                    "No pending requests found",
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ],
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
                  mainAxisExtent: 220, // Height adjusted to fit buttons
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
                      bool alreadyVerified = user['isVerified'] ?? false;

                      return _buildProfessionalCard(
                        user,
                        requestData,
                        userId,
                        requestId,
                        alreadyVerified,
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

  Widget _buildProfessionalCard(
    Map<String, dynamic> user,
    Map<String, dynamic> request,
    String uId,
    String rId,
    bool isVerified,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                            user['name'] ?? "Unknown",
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
              _statusBadge(request['mediaUrls']?['status'] ?? "pending"),
            ],
          ),
          const Gap(15),
          const Divider(height: 1),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniDetail(Icons.public, user['country'] ?? "N/A"),
              _miniDetail(
                Icons.devices,
                request['mediaUrls']?['platform'] ?? "N/A",
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _approveRequest(uId, rId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4318FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Approve",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _miniDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const Gap(5),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ],
    );
  }
}

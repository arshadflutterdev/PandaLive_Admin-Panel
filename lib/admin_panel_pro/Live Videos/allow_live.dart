import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllowLiveUser extends StatefulWidget {
  const AllowLiveUser({super.key});

  @override
  State<AllowLiveUser> createState() => _AllowLiveUserState();
}

class _AllowLiveUserState extends State<AllowLiveUser> {
  // Logic to Approve User
  Future<void> approveUser(String uid) async {
    try {
      // 1. Main profile update karein
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .update({"isVerified": "approved"});

      // 2. Subcollection status update karein
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .collection("isUserValid")
          .doc("verification_details")
          .update({"status": "approved"});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User Approved successfully!")),
      );
    } catch (e) {
      print("Error approving: $e");
    }
  }

  // Logic to Reject (Delete) Request
  Future<void> rejectUser(String uid) async {
    try {
      // 1. Subcollection wala data delete karein
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .collection("isUserValid")
          .doc("verification_details")
          .delete();

      // 2. Main profile status revert karein (ya "rejected" likh dein)
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .update({"isVerified": "rejected"});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request Rejected & Deleted")),
      );
    } catch (e) {
      print("Error rejecting: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Verifications"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      // StreamBuilder use karein taake real-time data dikhe
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup(
              'isUserValid',
            ) // Saari subcollections mein dhoondega
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending requests found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String uid = data['userId'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(data['name'][0]),
                  ),
                  title: Text(data['name'] ?? "Unknown"),
                  subtitle: Text("ID: ${data['shortId']}"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            "ID Documents (Base64 Preview):",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Agar Base64 string hai toh image dikhane ke liye:
                          // Image.memory(base64Decode(data['idCardFront'])),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () => approveUser(uid),
                                child: const Text(
                                  "Approve",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => rejectUser(uid),
                                child: const Text(
                                  "Reject",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

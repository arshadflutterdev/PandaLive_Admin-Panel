import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// --- MODEL CLASS ---
class SupportRequestModel {
  final String id;
  final String description;
  final String contactNumber;
  final String status;
  final List<String> imageUrls;
  final DateTime createdAt;
  final String userId;

  SupportRequestModel({
    required this.id,
    required this.description,
    required this.contactNumber,
    required this.status,
    required this.imageUrls,
    required this.createdAt,
    required this.userId,
  });

  factory SupportRequestModel.fromJson(
    Map<String, dynamic> json,
    String docId,
    String uId,
  ) {
    return SupportRequestModel(
      id: docId,
      description: json['description'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      status: json['status'] ?? 'pending',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      userId: uId,
    );
  }
}

// --- MAIN SCREEN ---
class SupportAdminPage extends StatefulWidget {
  @override
  _SupportAdminPageState createState() => _SupportAdminPageState();
}

class _SupportAdminPageState extends State<SupportAdminPage> {
  // 1. Mark as Solved Logic
  void _markAsSolved(SupportRequestModel request) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(request.userId)
          .collection('help_requests')
          .doc(request.id)
          .update({'status': 'solved'});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Request marked as solved!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // 2. Delete Logic
  void _deleteRequest(SupportRequestModel request) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Kya aap waqai is request ko delete karna chahte hain?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(request.userId)
          .collection('help_requests')
          .doc(request.id)
          .delete();
    }
  }

  // 3. Info Dialog with Gallery (6 Images support)
  void _showInfoDialog(SupportRequestModel request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Support Request Details"),
        content: Container(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _label("Description"),
                Text(request.description),
                Divider(),
                _label("Contact Number"),
                Text(request.contactNumber),
                Divider(),
                _label("Images (${request.imageUrls.length}/6)"),
                SizedBox(height: 10),
                if (request.imageUrls.isEmpty)
                  Text("No images attached.")
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: request.imageUrls.length,
                    itemBuilder: (ctx, index) => GestureDetector(
                      onTap: () => _viewFullImage(request.imageUrls[index]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          request.imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _viewFullImage(String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(child: Center(child: Image.network(url))),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Support Requests Management")),
      body: StreamBuilder<QuerySnapshot>(
        // Using CollectionGroup to get all help_requests from all users
        stream: FirebaseFirestore.instance
            .collectionGroup('help_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Contact")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: docs.map((doc) {
                  // Getting parent UserID from the document path
                  String uId = doc.reference.parent.parent!.id;
                  var request = SupportRequestModel.fromJson(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                    uId,
                  );

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          DateFormat(
                            'dd MMM, hh:mm a',
                          ).format(request.createdAt),
                        ),
                      ),
                      DataCell(Text(request.contactNumber)),
                      DataCell(
                        Text(
                          request.description,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              onPressed: () => _showInfoDialog(request),
                              tooltip: "View Details",
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              onPressed: () => _markAsSolved(request),
                              tooltip: "Mark Solved",
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRequest(request),
                              tooltip: "Delete",
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

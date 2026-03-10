import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class SupportAdminScreen extends StatefulWidget {
  @override
  _SupportAdminScreenState createState() => _SupportAdminScreenState();
}

class _SupportAdminScreenState extends State<SupportAdminScreen> {
  String selectedTab = "Pending";

  // --- ACTIONS ---
  void _updateStatus(String userId, String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('help_requests')
          .doc(docId)
          .update({'status': newStatus.toLowerCase()});

      _showSnackBar("Request marked as $newStatus", Colors.green);
    } catch (e) {
      _showSnackBar("Error: $e", Colors.redAccent);
    }
  }

  void _deleteRequest(String userId, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userId)
          .collection('help_requests')
          .doc(docId)
          .delete();
      _showSnackBar("Request deleted successfully", Colors.blueGrey);
    } catch (e) {
      _showSnackBar("Error: $e", Colors.redAccent);
    }
  }

  void _showSnackBar(String msg, Color bg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F6F9), // Professional light background
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP HEADER & TABS
            Row(
              children: [
                _buildTab("Pending"),
                SizedBox(width: 12),
                _buildTab("Solved"),
                Spacer(),
                _buildHeaderAction("All"),
              ],
            ),
            SizedBox(height: 25),

            // DATA TABLE CONTAINER
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTableTopBar(),
                    Divider(height: 1),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collectionGroup('help_requests')
                            .where(
                              'status',
                              isEqualTo: selectedTab.toLowerCase(),
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());
                          var docs = snapshot.data!.docs;
                          if (docs.isEmpty)
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "No $selectedTab requests found.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              horizontalMargin: 20,
                              columnSpacing: 30,
                              headingRowHeight: 60,
                              dataRowHeight: 70,
                              columns: [
                                DataColumn(
                                  label: Text("NO", style: _columnStyle()),
                                ),
                                DataColumn(
                                  label: Text(
                                    "UNIQUE ID",
                                    style: _columnStyle(),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "USER NAME",
                                    style: _columnStyle(),
                                  ),
                                ),
                                DataColumn(
                                  label: Text("DATE", style: _columnStyle()),
                                ),
                                DataColumn(
                                  label: Text("INFO", style: _columnStyle()),
                                ),
                                DataColumn(
                                  label: Text("ACTION", style: _columnStyle()),
                                ),
                              ],
                              rows: List.generate(docs.length, (index) {
                                var data =
                                    docs[index].data() as Map<String, dynamic>;
                                String uId =
                                    docs[index].reference.parent.parent!.id;
                                DateTime dt = (data['createdAt'] as Timestamp)
                                    .toDate();

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    DataCell(_buildIdCell(docs[index].id)),
                                    DataCell(
                                      _buildUserCell(
                                        data['userName'] ?? "Arshad Lashari",
                                        uId,
                                      ),
                                    ), // Using real name if exists
                                    DataCell(
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat(
                                              'dd MMM, yyyy',
                                            ).format(dt),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a').format(dt),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(_infoIcon(data)),
                                    DataCell(
                                      Row(
                                        children: [
                                          _actionBtn(
                                            Icons.check_circle_rounded,
                                            Colors.green,
                                            () => _updateStatus(
                                              uId,
                                              docs[index].id,
                                              "Solved",
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          _actionBtn(
                                            Icons.delete_sweep_rounded,
                                            Colors.redAccent,
                                            () => _deleteRequest(
                                              uId,
                                              docs[index].id,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CUSTOM WIDGETS ---

  Widget _buildTab(String title) {
    bool isSelected = selectedTab == title;
    return InkWell(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIdCell(String id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          id.substring(0, 8),
          style: TextStyle(fontFamily: 'monospace', color: Colors.blueGrey),
        ),
        IconButton(
          icon: Icon(Icons.copy, size: 14, color: Colors.grey),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: id));
            _showSnackBar("ID Copied", Colors.black);
          },
        ),
      ],
    );
  }

  Widget _buildUserCell(String name, String uId) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          child: Text(
            name[0].toUpperCase(),
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          ),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              "UID: ${uId.substring(0, 5)}...",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableTopBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Support Management",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey[900],
            ),
          ),
          Container(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search requests...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFF8F9FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback fn) {
    return IconButton(
      icon: Icon(icon, color: color, size: 22),
      onPressed: fn,
      style: IconButton.styleFrom(backgroundColor: color.withOpacity(0.05)),
    );
  }

  Widget _infoIcon(Map<String, dynamic> data) {
    return IconButton(
      icon: Icon(Icons.visibility_outlined, color: Colors.indigo),
      onPressed: () => _showDetailDialog(data),
    );
  }

  TextStyle _columnStyle() => TextStyle(
    color: Colors.blueGrey[400],
    fontWeight: FontWeight.bold,
    fontSize: 12,
    letterSpacing: 1,
  );

  Widget _buildHeaderAction(String text) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: Size(100, 48),
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> data) {
    List<String> imgs = List<String>.from(data['imageUrls'] ?? []);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Request Details"),
        content: Container(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailField("Problem Description", data['description']),
              _detailField("Contact Number", data['contactNumber']),
              SizedBox(height: 15),
              Text(
                "Attached Images (${imgs.length}/6)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              if (imgs.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: imgs
                      .map(
                        (u) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            u,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                Text(
                  "No evidence provided.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  Widget _detailField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value?.toString() ?? "N/A",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

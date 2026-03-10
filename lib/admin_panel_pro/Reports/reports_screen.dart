import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LiveStreamers extends StatefulWidget {
  const LiveStreamers({super.key});

  @override
  State<LiveStreamers> createState() => _LiveStreamersState();
}

class _LiveStreamersState extends State<LiveStreamers> {
  final CollectionReference liveStream = FirebaseFirestore.instance.collection(
    "LiveStream",
  );

  // Admin status toggle function
  // Admin side toggle function
  Future<void> toggleLiveStatus(String docId, bool currentStatus) async {
    await liveStream.doc(docId).update({
      'isLive': !currentStatus,
      'status': !currentStatus
          ? "online"
          : "blocked", // Flag for the app to listen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: liveStream.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          return Theme(
            // Table ki styling ko modern banane ke liye theme
            data: Theme.of(context).copyWith(dividerColor: Colors.grey[200]),
            child: DataTable(
              headingRowHeight: 50,
              dataRowHeight: 70,
              horizontalMargin: 20,
              columns: _buildColumns(),
              rows: List.generate(docs.length, (index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final docId = docs[index].id;
                bool isLive = data['isLive'] ?? true;

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    DataCell(_buildUserCell(data)),
                    DataCell(_buildStreamingTypeTag()),
                    DataCell(_buildStatusSwitch(docId, isLive)),
                    DataCell(_buildVideoIcon()),
                    DataCell(_buildActionButtons(docId)),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  // Header Columns
  List<DataColumn> _buildColumns() {
    const textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 13,
    );
    return const [
      DataColumn(label: Text('NO', style: textStyle)),
      DataColumn(label: Text('USER', style: textStyle)),
      DataColumn(label: Text('STREAMING TYPE', style: textStyle)),
      DataColumn(label: Text('LIVE STATUS', style: textStyle)),
      DataColumn(label: Text('VIDEO', style: textStyle)),
      DataColumn(label: Text('ACTION', style: textStyle)),
    ];
  }

  // User Profile Cell
  Widget _buildUserCell(Map<String, dynamic> data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200],
          backgroundImage: data['image'] != null
              ? NetworkImage(data['image'])
              : null,
          child: data['image'] == null
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data['hostname'] ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              data['uid']?.toString().substring(0, 8) ?? 'ID: ---',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  // Normal Live Tag
  Widget _buildStreamingTypeTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6), // Light blue tint
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        "Normal Live",
        style: TextStyle(
          color: Color(0xFF3F51B5),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Custom Styled Switch
  Widget _buildStatusSwitch(String docId, bool isLive) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: isLive,
        activeColor: Colors.blue,
        onChanged: (value) => toggleLiveStatus(docId, isLive),
      ),
    );
  }

  // Video Camera Icon
  Widget _buildVideoIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.videocam, color: Colors.indigoAccent, size: 20),
    );
  }

  // Action Buttons (Edit/Delete)
  Widget _buildActionButtons(String docId) {
    return Row(
      children: [
        _iconButton(Icons.edit_outlined, Colors.grey, () {}),
        const SizedBox(width: 8),
        _iconButton(Icons.delete_outline, Colors.grey, () {
          // Delete logic
          liveStream.doc(docId).delete();
        }),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

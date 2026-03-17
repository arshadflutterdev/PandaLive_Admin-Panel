import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReactionsScreen extends StatefulWidget {
  const ReactionsScreen({super.key});

  @override
  State<ReactionsScreen> createState() => _ReactionsScreenState();
}

class _ReactionsScreenState extends State<ReactionsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Professional Light Grey
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Manage Reactions",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () => _showReactionDialog(),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text("Create New"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF), // Modern Purple
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('reactions')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Something went wrong"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 280,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return _buildPremiumCard(data);
            },
          );
        },
      ),
    );
  }

  Widget _buildPremiumCard(DocumentSnapshot doc) {
    bool isActive = doc['isActive'] ?? true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ), // Inner border effect
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Status Badge & Switch
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? "Active" : "Hidden",
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isActive,
                    activeColor: const Color(0xFF6C63FF),
                    onChanged: (val) => _firestore
                        .collection('reactions')
                        .doc(doc.id)
                        .update({'isActive': val}),
                  ),
                ),
              ],
            ),
          ),

          // Image Preview
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF8F9FF,
                ), // Subtle background for the emoji
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    doc['image'],
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Footer: Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  Icons.edit_rounded,
                  Colors.blue,
                  () => _showReactionDialog(doc: doc),
                ),
                const VerticalDivider(width: 1),
                _actionButton(
                  Icons.delete_outline_rounded,
                  Colors.red,
                  () => _deleteReaction(doc.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 20, color: color.withOpacity(0.8)),
      ),
    );
  }

  // --- Dialog & Logic ---
  void _showReactionDialog({DocumentSnapshot? doc}) {
    TextEditingController imgController = TextEditingController(
      text: doc != null ? doc['image'] : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(doc == null ? "New Reaction" : "Update Reaction"),
        content: TextField(
          controller: imgController,
          decoration: InputDecoration(
            hintText: "Paste Image or GIF URL",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (doc == null) {
                _firestore.collection('reactions').add({
                  'image': imgController.text,
                  'isActive': true,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } else {
                _firestore.collection('reactions').doc(doc.id).update({
                  'image': imgController.text,
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
            ),
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  void _deleteReaction(String id) {
    // Confirm delete dialog asani se add ho sakta hai
    _firestore.collection('reactions').doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Reactions Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () => _showReactionDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add New"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('reactions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisExtent: 260,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return _buildReactionCard(data);
            },
          );
        },
      ),
    );
  }

  Widget _buildReactionCard(DocumentSnapshot doc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          PositionPoint(doc: doc), // Toggle Switch for Status
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Reaction Preview
              Center(
                child: Image.network(
                  doc['image'],
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.emoji_emotions,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _showReactionDialog(doc: doc),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => _deleteReaction(doc.id),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Functions ---

  void _showReactionDialog({DocumentSnapshot? doc}) {
    TextEditingController imgController = TextEditingController(
      text: doc != null ? doc['image'] : "",
    );
    bool isActive = doc != null ? doc['isActive'] : true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(doc == null ? "Add Reaction" : "Edit Reaction"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: imgController,
              decoration: const InputDecoration(
                labelText: "Image URL (Temporary)",
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "(Note: Support .png, .jpg, .gif, .webp)",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
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
                  'isActive': isActive,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } else {
                _firestore.collection('reactions').doc(doc.id).update({
                  'image': imgController.text,
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteReaction(String id) {
    _firestore.collection('reactions').doc(id).delete();
  }
}

class PositionPoint extends StatelessWidget {
  final DocumentSnapshot doc;
  const PositionPoint({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      right: 5,
      child: Switch(
        value: doc['isActive'] ?? true,
        onChanged: (val) {
          FirebaseFirestore.instance.collection('reactions').doc(doc.id).update(
            {'isActive': val},
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Add this for animations

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  late TextEditingController _coinController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _coinController = TextEditingController();
    _imageController = TextEditingController();
  }

  @override
  void dispose() {
    _coinController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  // Check if link is a Lottie Animation
  bool _isAnimation(String url) {
    return url.toLowerCase().contains('.json');
  }

  Future<void> _addGift() async {
    if (_coinController.text.isEmpty || _imageController.text.isEmpty) {
      _msg("Please fill all fields");
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('gifts').add({
        'coin': int.tryParse(_coinController.text) ?? 0,
        'image': _imageController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      _coinController.clear();
      _imageController.clear();
      if (mounted) Navigator.pop(context);
      _msg("New Gift Added!");
    } catch (e) {
      _msg("Error: $e");
    }
  }

  Future<void> _deleteGift(String id) async {
    await FirebaseFirestore.instance.collection('gifts').doc(id).delete();
    _msg("Gift Deleted");
  }

  void _msg(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          "PandaLive Gifts",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: _showAddGiftDialog,
              icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gifts')
            .orderBy('coin')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final gifts = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 220,
            ),
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              var gift = gifts[index].data() as Map<String, dynamic>;
              return _buildGiftCard(gift, gifts[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift, String id) {
    String url = gift['image'] ?? "";
    bool isAnim = _isAnimation(url);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: isAnim
                  ? Lottie.network(
                      url,
                      repeat: true,
                      reverse: true,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.videocam_off_outlined),
                    )
                  : Image.network(
                      url,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                    ),
            ),
          ),
          if (isAnim)
            const Text(
              "ANIMATED",
              style: TextStyle(
                fontSize: 9,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${gift['coin']} 🪙",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _deleteGift(id),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGiftDialog() {
    _coinController.clear();
    _imageController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Gift / Animation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: "URL (Image or Lottie JSON)",
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(15),
            TextField(
              controller: _coinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Coins",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(onPressed: _addGift, child: const Text("Save")),
        ],
      ),
    );
  }
}

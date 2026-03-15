import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  late TextEditingController _coinController;
  late TextEditingController _imageController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _coinController = TextEditingController();
    _imageController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _coinController.dispose();
    _imageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isAnimation(String url) => url.toLowerCase().contains('.json');

  Future<void> _addGift() async {
    if (_coinController.text.isEmpty ||
        _imageController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _msg("Please fill all fields");
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('gifts').add({
        'name': _nameController.text.trim(),
        'coin': int.tryParse(_coinController.text) ?? 0,
        'image': _imageController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      _coinController.clear();
      _imageController.clear();
      _nameController.clear();
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

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
              crossAxisCount: screenWidth < 600 ? 2 : 5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 260,
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
    String giftName = gift['name'] ?? "No Name";
    bool isAnim = _isAnimation(url);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: isAnim
                  ? Lottie.network(
                      url,
                      repeat: true,
                      animate: true,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    )
                  : Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.image_not_supported, size: 40),
                    ),
            ),
          ),
          Text(
            giftName,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          if (isAnim)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "ANIMATED",
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${gift['coin']} 🪙",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: () => _deleteGift(id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
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
    _nameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Create New Gift",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(
                _nameController,
                "Gift Name (e.g. Lion)",
                Icons.label_outline,
              ),
              const Gap(15),
              _dialogField(_imageController, "Image/JSON URL", Icons.link),
              const Gap(15),
              _dialogField(
                _coinController,
                "Coin Value",
                Icons.monetization_on_outlined,
                isNumber: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _addGift,
            child: const Text("Save Gift"),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
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
  late TextEditingController _nameController;

  PlatformFile? _selectedFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _coinController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _coinController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // File picker function
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'gif', 'webp', 'json'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _addGift() async {
    if (_nameController.text.isEmpty ||
        _coinController.text.isEmpty ||
        _selectedFile == null) {
      _msg("Please fill all fields and select a file");
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Upload to Firebase Storage
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.name}";
      Reference storageRef = FirebaseStorage.instance.ref().child(
        "gifts/$fileName",
      );

      UploadTask uploadTask = storageRef.putData(_selectedFile!.bytes!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // 2. Save to Firestore
      await FirebaseFirestore.instance.collection('gifts').add({
        'name': _nameController.text.trim(),
        'coin': int.tryParse(_coinController.text) ?? 0,
        'image': downloadUrl,
        'isAnimation': _selectedFile!.name.toLowerCase().endsWith('.json'),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
      _msg("New Gift Added Successfully!");
      _clearFields();
    } catch (e) {
      _msg("Upload Error: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _clearFields() {
    _coinController.clear();
    _nameController.clear();
    _selectedFile = null;
  }

  Future<void> _deleteGift(String id, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('gifts').doc(id).delete();
      // Optional: Delete from Storage as well
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      _msg("Gift Deleted");
    } catch (e) {
      _msg("Delete Error: $e");
    }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGiftDialog,
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add New Gift",
          style: TextStyle(color: Colors.white),
        ),
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
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 600 ? 2 : 5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 280,
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
    bool isAnim = gift['isAnimation'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: isAnim
                  ? Lottie.network(url, repeat: true)
                  : Image.network(url, fit: BoxFit.contain),
            ),
          ),
          Text(
            gift['name'] ?? "No Name",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          if (isAnim)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: _badge("ANIMATED", Colors.blue),
            ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${gift['coin']} 🪙",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    color: Colors.orange[800],
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteGift(id, url),
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

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddGiftDialog() {
    _clearFields();
    showDialog(
      context: context,
      barrierDismissible: !_isUploading,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Text(
              "Add Professional Gift",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(_nameController, "Gift Name", Icons.label_outline),
                const Gap(15),
                _dialogField(
                  _coinController,
                  "Coin Value",
                  Icons.monetization_on_outlined,
                  isNumber: true,
                ),
                const Gap(20),

                // File Selector UI
                GestureDetector(
                  onTap: () async {
                    await _pickFile();
                    setDialogState(() {}); // Refresh dialog UI
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedFile == null
                              ? Icons.cloud_upload_outlined
                              : Icons.check_circle,
                          color: _selectedFile == null
                              ? Colors.grey
                              : Colors.green,
                          size: 30,
                        ),
                        const Gap(8),
                        Text(
                          _selectedFile?.name ?? "Click to Upload Image/JSON",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isUploading)
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: _isUploading ? null : () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                ),
                onPressed: _isUploading ? null : _addGift,
                child: Text(_isUploading ? "Uploading..." : "Save Gift"),
              ),
            ],
          );
        },
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
      ),
    );
  }
}

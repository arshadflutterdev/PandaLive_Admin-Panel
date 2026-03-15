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
  double _uploadProgress = 0.0; // Real-time progress variable

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

  Future<void> _pickFile(StateSetter setDialogState) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'gif', 'webp', 'json'],
        withData: true,
      );

      if (result != null) {
        setDialogState(() {
          _selectedFile = result.files.first;
        });
        print("DEBUG: File selected - ${_selectedFile!.name}");
      }
    } catch (e) {
      print("DEBUG ERROR (PickFile): $e");
      _msg("Error picking file: $e");
    }
  }

  Future<void> _addGift() async {
    // 1. Double-click protection aur field check
    if (_isUploading ||
        _nameController.text.isEmpty ||
        _coinController.text.isEmpty ||
        _selectedFile == null) {
      if (!_isUploading) _msg("Please fill all fields");
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      print("DEBUG: Starting Upload Process...");
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.name}";
      Reference storageRef = FirebaseStorage.instance.ref().child(
        "gifts/$fileName",
      );

      SettableMetadata metadata = SettableMetadata(
        contentType: _selectedFile!.name.endsWith('.json')
            ? 'application/json'
            : 'image/jpeg', // JPG ke liye image/jpeg behtar hai
      );

      // Start Upload Task
      UploadTask uploadTask = storageRef.putData(
        _selectedFile!.bytes!,
        metadata,
      );

      // Real-time listener for progress
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          if (snapshot.totalBytes > 0) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            print("DEBUG: Progress: ${(progress * 100).toStringAsFixed(2)}%");

            if (mounted) {
              setState(() {
                _uploadProgress = progress;
              });
            }
          }
        },
        onError: (e) {
          print("DEBUG ERROR (Upload Stream): $e");
          setState(() => _isUploading = false);
        },
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("DEBUG: Success! URL: $downloadUrl");

      await FirebaseFirestore.instance.collection('gifts').add({
        'name': _nameController.text.trim(),
        'coin': int.tryParse(_coinController.text) ?? 0,
        'image': downloadUrl,
        'isAnimation': _selectedFile!.name.toLowerCase().endsWith('.json'),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
      _msg("Gift Uploaded Successfully!");
      _clearFields();
    } catch (e) {
      print("DEBUG ERROR (Main Catch): $e");
      _msg("Upload failed: $e");
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _clearFields() {
    _coinController.clear();
    _nameController.clear();
    _selectedFile = null;
    _uploadProgress = 0.0;
  }

  void _msg(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text(
          "PandaLive Gifts",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGiftDialog,
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add_to_photos, color: Colors.white),
        label: const Text("Create Gift", style: TextStyle(color: Colors.white)),
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

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth < 600
                  ? 2
                  : (constraints.maxWidth < 1200 ? 4 : 6);
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  var gift = gifts[index].data() as Map<String, dynamic>;
                  return _buildGiftCard(gift, gifts[index].id);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift, String id) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: gift['isAnimation'] == true
                  ? Lottie.network(gift['image'], fit: BoxFit.contain)
                  : Image.network(
                      gift['image'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stack) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Text(
                  gift['name'] ?? "Gift",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${gift['coin']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.orange,
                      ),
                    ),
                    const Gap(4),
                    const Icon(
                      Icons.monetization_on,
                      size: 14,
                      color: Colors.orange,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => FirebaseFirestore.instance
                      .collection('gifts')
                      .doc(id)
                      .delete(),
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.redAccent,
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text("Add Professional Gift"),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField(_nameController, "Gift Name", Icons.edit),
                    const Gap(15),
                    _dialogField(
                      _coinController,
                      "Coin Value",
                      Icons.generating_tokens,
                      isNumber: true,
                    ),
                    const Gap(20),
                    GestureDetector(
                      onTap: () => _pickFile(setDialogState),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _selectedFile == null
                                  ? Icons.upload_file
                                  : Icons.task_alt,
                              color: _selectedFile == null
                                  ? Colors.blueAccent
                                  : Colors.green,
                              size: 40,
                            ),
                            const Gap(10),
                            Text(
                              _selectedFile?.name ??
                                  "Tap to Select SVGA/WebP/JSON",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Real-time Progress Bar in Dialog
                    if (_isUploading) ...[
                      const Gap(20),
                      LinearProgressIndicator(value: _uploadProgress),
                      const Gap(5),
                      Text(
                        "${(_uploadProgress * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: _isUploading ? null : _addGift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                ),
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
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

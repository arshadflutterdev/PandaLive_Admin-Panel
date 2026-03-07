import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifyUsers extends StatefulWidget {
  const NotifyUsers({super.key});

  @override
  State<NotifyUsers> createState() => _NotifyUsersState();
}

class _NotifyUsersState extends State<NotifyUsers> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isSending = false;

  // --- Send Announcement Logic ---
  Future<void> _sendAnnouncement() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      Get.snackbar("Error", "Please fill both fields");
      return;
    }

    setState(() => _isSending = true);

    try {
      // 1. Get all users
      var usersSnapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .get();

      // 2. Loop through all users and add notification
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in usersSnapshot.docs) {
        var notificationRef = FirebaseFirestore.instance
            .collection("userProfile")
            .doc(doc.id)
            .collection("notifications")
            .doc(); // Naya ID generate hoga

        batch.set(notificationRef, {
          "title": _titleController.text,
          "body": _bodyController.text,
          "time": FieldValue.serverTimestamp(),
          "type":
              "announcement", // Pehchan ke liye ke ye admin notification hai
        });
      }

      await batch.commit();

      _titleController.clear();
      _bodyController.clear();

      Get.snackbar(
        "Success",
        "Announcement sent to ${usersSnapshot.docs.length} users",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to send: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? "إرسال إعلان" : "Send Announcement"),
        backgroundColor: const Color(0xff0D1A63),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? "عنوان الإعلان" : "Announcement Title",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              decoration: InputDecoration(
                hintText: isArabic
                    ? "أدخل العنوان هنا..."
                    : "Enter title here...",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isArabic ? "محتوى الإعلان" : "Announcement Body (Subtitle)",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              decoration: InputDecoration(
                hintText: isArabic
                    ? "أدخل التفاصيل هنا..."
                    : "Enter details here...",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendAnnouncement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D1A63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: _isSending
                    ? const SizedBox.shrink()
                    : const Icon(Icons.campaign, color: Colors.white),
                label: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isArabic
                            ? "إرسال إلى جميع المستخدمين"
                            : "Send to All Users",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

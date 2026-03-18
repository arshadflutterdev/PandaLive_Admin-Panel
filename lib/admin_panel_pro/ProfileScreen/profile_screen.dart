// import 'package:flutter/material.dart';
// import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController nameController = TextEditingController(
//     text: "Al Zahrani",
//   );
//   final TextEditingController emailController = TextEditingController(
//     text: "alzahrani.com",
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           // Check if screen is mobile or desktop
//           bool isMobile = constraints.maxWidth < 800;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "App Setting",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Top Section: Avatar and Edit Profile
//                 if (isMobile)
//                   Column(
//                     children: [
//                       _buildAvatarSection(),
//                       const SizedBox(height: 20),
//                       _buildEditProfileSection(),
//                     ],
//                   )
//                 else
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(child: _buildAvatarSection()),
//                       const SizedBox(width: 20),
//                       Expanded(child: _buildEditProfileSection()),
//                     ],
//                   ),

//                 const SizedBox(height: 20),

//                 // Bottom Section: Change Password
//                 // Responsive width: Desktop par 50% aur Mobile par full width
//                 SizedBox(
//                   width: isMobile
//                       ? double.infinity
//                       : constraints.maxWidth * 0.49,
//                   child: _buildChangePasswordSection(),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // --- UI Sections extracted for clean responsiveness ---

//   Widget _buildAvatarSection() {
//     return _buildCard(
//       child: Column(
//         children: [
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Profile Avatar",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//           ),
//           const SizedBox(height: 40),
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: const Color(0xFF6C63FF).withOpacity(0.5),
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: Image(image: AssetImage(AppImages.user), height: 150),
//                 ),
//               ),
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF6C63FF),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Icon(Icons.edit, color: Colors.white, size: 18),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "Al Zahrani",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditProfileSection() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Edit Profile",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           const SizedBox(height: 25),
//           _buildLabel("Name"),
//           _buildTextField(nameController),
//           const SizedBox(height: 20),
//           _buildLabel("Email"),
//           _buildTextField(emailController),
//           const SizedBox(height: 30),
//           Align(alignment: Alignment.centerRight, child: _buildSubmitButton()),
//         ],
//       ),
//     );
//   }

//   Widget _buildChangePasswordSection() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Change Password",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           const SizedBox(height: 25),
//           _buildLabel("Old Password"),
//           _buildTextField(TextEditingController(), isPassword: true),
//           const SizedBox(height: 20),
//           LayoutBuilder(
//             builder: (context, subConstraints) {
//               // Internal Row responsiveness for passwords
//               if (subConstraints.maxWidth < 500) {
//                 return Column(
//                   children: [
//                     _buildLabel("New Password"),
//                     _buildTextField(
//                       TextEditingController(),
//                       isPassword: true,
//                       hint: "Enter New Password",
//                     ),
//                     const SizedBox(height: 20),
//                     _buildLabel("Confirm Password"),
//                     _buildTextField(
//                       TextEditingController(),
//                       isPassword: true,
//                       hint: "Enter Confirm Password",
//                     ),
//                   ],
//                 );
//               }
//               return Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildLabel("New Password"),
//                         _buildTextField(
//                           TextEditingController(),
//                           isPassword: true,
//                           hint: "Enter New Password",
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildLabel("Confirm Password"),
//                         _buildTextField(
//                           TextEditingController(),
//                           isPassword: true,
//                           hint: "Enter Confirm Password",
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           const SizedBox(height: 30),
//           Align(alignment: Alignment.centerRight, child: _buildSubmitButton()),
//         ],
//       ),
//     );
//   }

//   // --- Helper Widgets ---

//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF4CAF50),
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       child: const Text("Submit", style: TextStyle(color: Colors.white)),
//     );
//   }

//   Widget _buildCard({required Widget child, double? width}) {
//     return Container(
//       width: width,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _buildLabel(String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.black54,
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller, {
//     bool isPassword = false,
//     String? hint,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: const Color(0xFFF8F9FB),
//         suffixIcon: isPassword
//             ? const Icon(Icons.visibility_off_outlined, size: 20)
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade200),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  // --- 1. Fetch from 'userProfile' ---
  Future<void> _fetchAdminData() async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) return;

      // Ab hum 'userProfile' collection se data le rahe hain
      DocumentSnapshot userDoc = await _db
          .collection('userProfile')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = data['name'] ?? "No Name";
          emailController.text =
              data['email'] ?? _auth.currentUser?.email ?? "";
          profileImageUrl = data['userimage'];
          isLoading = false;
        });

        // Role check logic
        if (data['role'] == null) {
          await _db.collection('userProfile').doc(uid).update({
            "role": "super_admin",
            "status": "active",
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("::: Error syncing data: $e :::");
      setState(() => isLoading = false);
    }
  }

  // --- 2. Change Image (Updates userProfile) ---
  Future<void> _changeProfileImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => isLoading = true);
      try {
        String uid = _auth.currentUser!.uid;
        Uint8List fileBytes = await image.readAsBytes();

        Reference ref = FirebaseStorage.instance
            .ref()
            .child('adminImages')
            .child('$uid.jpg');

        await ref.putData(
          fileBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        String downloadUrl = await ref.getDownloadURL();

        // Update in 'userProfile'
        await _db.collection('userProfile').doc(uid).update({
          "userimage": downloadUrl,
        });

        setState(() {
          profileImageUrl = downloadUrl;
          isLoading = false;
        });

        Get.snackbar(
          "Success",
          "Profile Image Updated",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        setState(() => isLoading = false);
        Get.snackbar("Error", "Upload failed", backgroundColor: Colors.red);
      }
    }
  }

  // --- 3. Update Password ---
  Future<void> _updatePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match!",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPasswordController.text);

      Get.snackbar(
        "Success",
        "Password Updated",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Check your old password",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "App Setting",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (isMobile)
                  Column(
                    children: [
                      _buildAvatarSection(),
                      const SizedBox(height: 20),
                      _buildEditProfileSection(),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAvatarSection()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildEditProfileSection()),
                    ],
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: isMobile
                      ? double.infinity
                      : constraints.maxWidth * 0.49,
                  child: _buildChangePasswordSection(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection() {
    return _buildCard(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Profile Avatar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: _displayImage(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _changeProfileImage,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF6C63FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            nameController.text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _displayImage() {
    if (profileImageUrl != null && profileImageUrl!.startsWith('http')) {
      return Image.network(
        profileImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(AppImages.user, fit: BoxFit.cover),
      );
    } else {
      return Image.asset(AppImages.user, fit: BoxFit.cover);
    }
  }

  Widget _buildEditProfileSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          _buildLabel("Name"),
          _buildTextField(nameController),
          const SizedBox(height: 20),
          _buildLabel("Email"),
          _buildTextField(emailController, readOnly: true),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: _buildSubmitButton(
              onPressed: () async {
                String uid = _auth.currentUser!.uid;
                await _db.collection('userProfile').doc(uid).update({
                  "name": nameController.text,
                });
                Get.snackbar(
                  "Success",
                  "Name Updated",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                setState(() {}); // Refresh UI name
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Change Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          _buildLabel("Old Password"),
          _buildTextField(oldPasswordController, isPassword: true),
          const SizedBox(height: 20),
          _buildLabel("New Password"),
          _buildTextField(newPasswordController, isPassword: true),
          const SizedBox(height: 20),
          _buildLabel("Confirm Password"),
          _buildTextField(confirmPasswordController, isPassword: true),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: _buildSubmitButton(onPressed: _updatePassword),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller, {
    bool isPassword = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton({required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text("Submit", style: TextStyle(color: Colors.white)),
    );
  }
}

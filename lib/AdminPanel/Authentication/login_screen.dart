// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
// import 'package:panda_adminpanel/admin_panel_pro/HomeScreens/home_screen.dart';

// // Note: Ensure your Home Screen and Routes are correctly defined
// // import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final authController = Get.put(AdminAuthController());
//   bool _isRememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final bool isMobile = width < 900;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Row(
//         children: [
//           if (!isMobile)
//             Expanded(
//               flex: 1,
//               child: Container(
//                 margin: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6366F1),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                         width: width * 0.35,
//                         height: MediaQuery.of(context).size.height * 0.85,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(40),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.2),
//                             width: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(60.0),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             const Gap(40),
//                             Text(
//                               "Very good\nworks are\nwaiting for\nyou Login\nNow!!!",
//                               textAlign: TextAlign.right,
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: 42,
//                                 fontWeight: FontWeight.bold,
//                                 height: 1.2,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 8,
//                       right: 200,
//                       child: Image.asset(
//                         "assets/images/bggg.png",
//                         width: width * 0.3,
//                         height: 500,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isMobile ? 30 : width * 0.08,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         height: 75,
//                         width: 75,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Icon(
//                           Icons.flutter_dash,
//                           color: Colors.white,
//                           size: 45,
//                         ),
//                       ),
//                     ),
//                     const Gap(30),
//                     Text(
//                       "Login to your account",
//                       style: GoogleFonts.poppins(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Gap(10),
//                     const Text(
//                       "Let's connect, chat, and spark real connections. Enter your credentials to continue.",
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                     const Gap(35),
//                     const Text(
//                       "Enter your Email",
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     const Gap(8),
//                     TextField(
//                       controller: authController.emailController,
//                       decoration: InputDecoration(
//                         hintText: "Enter admin Email",
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     const Gap(20),
//                     const Text(
//                       "Enter your Password",
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     const Gap(8),
//                     Obx(
//                       () => TextField(
//                         controller: authController.passwordController,
//                         obscureText: !authController.isPasswordVisible.value,
//                         decoration: InputDecoration(
//                           hintText: "••••••••",

//                           prefixIcon: const Icon(Icons.lock_outline),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               authController.isPasswordVisible.value
//                                   ? Icons.visibility_outlined
//                                   : Icons.visibility_off_outlined,
//                             ),
//                             onPressed: () =>
//                                 authController.isPasswordVisible.toggle(),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Gap(15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: _isRememberMe,
//                               activeColor: const Color(0xFF6366F1),
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   _isRememberMe = value ?? false;
//                                 });
//                               },
//                             ),
//                             const Text("Remember me?"),
//                           ],
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: const Text("Forgot Password?"),
//                         ),
//                       ],
//                     ),
//                     const Gap(30),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: Obx(
//                         () => ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6366F1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onPressed: authController.isLoading.value
//                               ? null
//                               : () => authController.loginAdmin(),
//                           child: authController.isLoading.value
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "Admin Log In",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AdminAuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   var isLoading = false.obs;
//   var isPasswordVisible = false.obs;

//   // Aapka Master Email
//   final String masterEmail = "arshadbaloch0307@gmail.com";

//   Future<void> loginAdmin() async {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Fields cannot be empty",
//         backgroundColor: Colors.orange,
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // 1. Firebase Auth Login
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       String uid = userCredential.user!.uid;
//       String currentEmail = emailController.text.trim();

//       // Original Name nikalne ki koshish (Firebase Auth se)
//       String originalName = userCredential.user!.displayName ?? "Admin User";

//       // 2. userProfile collection check karein
//       DocumentReference userRef = FirebaseFirestore.instance
//           .collection('userProfile')
//           .doc(uid);
//       DocumentSnapshot userDoc = await userRef.get();

//       // --- AUTO ROLE & NAME LOGIC ---
//       if (currentEmail == masterEmail) {
//         Map<String, dynamic> updateData = {
//           'email': currentEmail,
//           'role': 'super_admin',
//           'status': 'active',
//           'uid': uid,
//         };

//         // Agar Firestore mein pehle se 'name' mojud hai, toh wahi rehne dein
//         // Agar nahi hai, toh Auth wala original name dal dein
//         if (!userDoc.exists ||
//             (userDoc.data() as Map<String, dynamic>)['name'] == null) {
//           updateData['name'] = originalName;
//         }

//         await userRef.set(updateData, SetOptions(merge: true));

//         // Refresh document after update
//         userDoc = await userRef.get();
//       }

//       // 3. Final Verification
//       if (userDoc.exists && userDoc['role'] == 'super_admin') {
//         isLoading.value = false;

//         // Success Snackbar mein Original Name show hoga
//         String finalName = userDoc['name'] ?? originalName;

//         Get.offAll(() => HomeScreenPro()); // Ya jo bhi aapka route hai
//         Get.snackbar(
//           "Success",
//           "Welcome Back, $finalName!",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         await _auth.signOut();
//         isLoading.value = false;
//         Get.snackbar(
//           "Access Denied",
//           "Aap admin nahi hain.",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar(
//         "Login Failed",
//         "Invalid Credentials",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPrewiew extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String docId;

  const UserPrewiew({super.key, required this.userData, required this.docId});

  @override
  State<UserPrewiew> createState() => _UserPrewiewState();
}

class _UserPrewiewState extends State<UserPrewiew> {
  bool isVerified = false;
  String currentRole = "user";

  @override
  void initState() {
    super.initState();
    // Initial data load from widget
    var verifiedData = widget.userData['isVerified'];
    isVerified = verifiedData is bool ? verifiedData : false;
    currentRole = widget.userData['role'] ?? "user";
  }

  // --- 1. Blue Tick Toggle ---
  Future<void> _toggleVerification() async {
    bool newStatus = !isVerified;
    await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(widget.docId)
        .update({"isVerified": newStatus});

    setState(() {
      isVerified = newStatus;
    });
  }

  // --- 2. Role Toggle (Make/Remove Admin) ---
  Future<void> _toggleAdminRole() async {
    try {
      // Agar pehle se admin hai toh 'user' kar do, warna 'admin'
      String newRole = (currentRole == "admin") ? "user" : "admin";

      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.docId)
          .update({"role": newRole});

      setState(() {
        currentRole = newRole;
      });

      Get.snackbar(
        "Success",
        newRole == "admin"
            ? "Admin bana diya gaya!"
            : "Admin rights khatam kar diye gaye!",
        backgroundColor: newRole == "admin" ? Colors.green : Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Role update nahi ho saka",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobile
                  ? Column(children: _buildProfileHeader(isMobile))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildProfileHeader(isMobile),
                    ),

              const Gap(40),
              const Divider(),
              const Gap(20),

              // Verification & Admin Buttons Row
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  _buildVerifyButton(),

                  // Logic: Super Admin ko koi remove nahi kar sakta
                  if (currentRole != "super_admin") _buildAdminToggleButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Naya Admin Toggle Button ---
  Widget _buildAdminToggleButton() {
    bool isAdmin = currentRole == "admin";
    return ElevatedButton.icon(
      onPressed: () {
        Get.defaultDialog(
          title: isAdmin ? "Remove Admin" : "Make Admin",
          middleText: isAdmin
              ? "Kya aap is user se Admin rights wapis lena chahte hain?"
              : "Kya aap is user ko Admin banana chahte hain?",
          textConfirm: "Haan",
          textCancel: "Nahi",
          confirmTextColor: Colors.white,
          onConfirm: () {
            _toggleAdminRole();
            Get.back();
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isAdmin ? Colors.redAccent : Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(200, 50),
      ),
      icon: Icon(isAdmin ? Icons.person_remove : Icons.security),
      label: Text(isAdmin ? "Remove as Admin" : "Make Admin"),
    );
  }

  // --- Baki UI Helper Methods ---
  List<Widget> _buildProfileHeader(bool isMobile) {
    return [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          widget.userData['userimage'] ?? "",
          width: isMobile ? double.infinity : 250,
          height: isMobile ? 300 : 250,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            width: isMobile ? double.infinity : 250,
            height: isMobile ? 300 : 250,
            color: Colors.grey[200],
            child: const Icon(Icons.person, size: 80),
          ),
        ),
      ),
      isMobile ? const Gap(20) : const Gap(30),
      Expanded(
        flex: isMobile ? 0 : 1,
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildProfileField(
              "Name",
              widget.userData['name'] ?? "N/A",
              isMobile,
            ),
            _buildProfileField(
              "User name",
              "@${widget.userData['userId'] ?? 'unknown'}",
              isMobile,
            ),
            _buildProfileField(
              "Gender",
              widget.userData['gender'] ?? "N/A",
              isMobile,
            ),
            _buildProfileField(
              "Country",
              widget.userData['country'] ?? "Global",
              isMobile,
            ),
            _buildProfileField(
              "Coins",
              "${widget.userData['coins'] ?? 0}",
              isMobile,
            ),
            _buildProfileField("Login Type", "Quick", isMobile),
          ],
        ),
      ),
    ];
  }

  Widget _buildVerifyButton() {
    return ElevatedButton.icon(
      onPressed: _toggleVerification,
      style: ElevatedButton.styleFrom(
        backgroundColor: isVerified ? Colors.blue : Colors.grey[200],
        foregroundColor: isVerified ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(200, 50),
      ),
      icon: Icon(isVerified ? Icons.verified : Icons.verified_outlined),
      label: Text(isVerified ? "Verified (Remove)" : "Give Blue Tick"),
    );
  }

  Widget _buildProfileField(String label, String value, bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
          ),
          const Gap(6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

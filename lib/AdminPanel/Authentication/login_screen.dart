// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/route_manager.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
// // Note: Apne project ke mutabiq import check kar lein
// // import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   // Remember me workable banane ke liye variable
//   bool _isRememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final bool isMobile = width < 900;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Row(
//         children: [
//           // --- LEFT SIDE: FIXED DESIGN WITH IMAGE ---
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
//                     // 1. Vertical Inner Shape
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

//                     // 2. Text Content (Top Right)
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

//                     // 3. Bottom Right Image (Mukammal Design)
//                     Positioned(
//                       bottom: 8,
//                       right: 200,
//                       child: Image.asset(
//                         "assets/images/bggg.png", // AppImages.bgrm use karein
//                         width: width * 0.3,
//                         height: 500,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           // --- RIGHT SIDE: LOGIN FORM ---
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
//                     // Logo
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
//                       decoration: InputDecoration(
//                         hintText: "demo@admin.com",
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
//                     TextField(
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         hintText: "••••••••",
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         suffixIcon: const Icon(Icons.visibility_off_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),

//                     const Gap(15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             // --- REMEMBER ME WORKABLE ---
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

//                     // Admin Login Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF6366F1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: () {
//                           print("Remember Me: $_isRememberMe");
//                           // Yahan apna login logic add karein
//                           Get.toNamed(AppRoutes.homepro);
//                         },
//                         child: const Text(
//                           "Admin Log In",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
// Note: Ensure your controller import is correct
// import 'package:panda_adminpanel/AdminPanel/Controllers/admin_auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller ko initialize kiya
  final authController = Get.put(AdminAuthController());
  bool _isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // --- LEFT SIDE: FIXED DESIGN WITH IMAGE ---
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.85,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Gap(40),
                            Text(
                              "Very good\nworks are\nwaiting for\nyou Login\nNow!!!",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 200,
                      child: Image.asset(
                        "assets/images/bggg.png",
                        width: width * 0.3,
                        height: 500,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // --- RIGHT SIDE: LOGIN FORM ---
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 30 : width * 0.08,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                    const Gap(30),

                    Text(
                      "Login to your account",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    const Text(
                      "Let's connect, chat, and spark real connections. Enter your credentials to continue.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Gap(35),

                    const Text(
                      "Enter your Email",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    TextField(
                      controller:
                          authController.emailController, // Added Controller
                      decoration: InputDecoration(
                        hintText: "Enter admin Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Gap(20),

                    const Text(
                      "Enter your Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    Obx(
                      () => TextField(
                        controller: authController
                            .passwordController, // Added Controller
                        obscureText: !authController
                            .isPasswordVisible
                            .value, // Observable logic
                        decoration: InputDecoration(
                          hintText: "••••••••",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () =>
                                authController.isPasswordVisible.toggle(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isRememberMe,
                              activeColor: const Color(0xFF6366F1),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isRememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text("Remember me?"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
                    const Gap(30),

                    // Admin Login Button Integrated with Logic
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: authController.isLoading.value
                              ? null
                              : () => authController.loginAdmin(), // Logic Call
                          child: authController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Admin Log In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  final String masterEmail = "arshadbaloch0307@gmail.com";

  // --- LOGIN LOGIC ---
  Future<void> loginAdmin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter credentials",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 1. Pehle check karo kya ye admin collection mein hai
      DocumentSnapshot adminDoc = await _db
          .collection('adminUsers')
          .doc(uid)
          .get();

      // 2. Agar Master Email hai lekin admin collection mein nahi hai (Jo aapka case hai)
      if (emailController.text.trim().toLowerCase() == masterEmail &&
          !adminDoc.exists) {
        // Screenshots ke mutabiq aapka data create kar dete hain admin collection mein
        await _db.collection('adminUsers').doc(uid).set({
          "name": "Arshad Lashari", // As per your screenshot
          "email": masterEmail,
          "dob": "01-01-2000",
          "gender": "Male",
          "userId": uid,
          "role": "super_admin",
          "status": "active",
          "createdAt": FieldValue.serverTimestamp(),
          "userimage":
              "https://lh3.googleusercontent.com/...", // image link auto pick ho jayega baad mein
        });

        // Refresh the doc reference
        adminDoc = await _db.collection('adminUsers').doc(uid).get();
      }

      // 3. Final Check for login
      if (adminDoc.exists) {
        if (adminDoc['status'] == 'active') {
          Get.snackbar(
            "Success",
            "Welcome Master Admin Arshad!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAllNamed(AppRoutes.homepro);
        } else {
          await _auth.signOut();
          Get.snackbar(
            "Pending",
            "Your admin status is not active.",
            backgroundColor: Colors.orange,
          );
        }
      } else {
        await _auth.signOut();
        Get.snackbar(
          "Access Denied",
          "You are not registered in Admin Panel.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Error",
        "Invalid Email or Password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

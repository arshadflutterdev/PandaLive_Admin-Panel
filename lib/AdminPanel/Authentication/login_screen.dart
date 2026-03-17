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
// import 'package:panda_adminpanel/AdminPanel/Controllers/admin_auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authController = Get.put(AdminAuthController());
  bool isLogin = true;
  bool _isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
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
                              isLogin
                                  ? "Very good\nworks are\nwaiting for\nyou Login\nNow!!!"
                                  : "Join us\nand start\nmanaging\neverything\nToday!!!",
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
                      isLogin
                          ? "Login to your account"
                          : "Create Admin Account",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      isLogin
                          ? "Enter your credentials to continue."
                          : "Register as a new administrator.",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Gap(30),

                    if (!isLogin) ...[
                      const Text(
                        "Full Name",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Gap(8),
                      _buildField(
                        authController.nameController,
                        "Arshad Lashari",
                        Icons.person_outline,
                      ),
                      const Gap(20),

                      const Text(
                        "Date of Birth",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Gap(8),
                      _buildField(
                        authController.dobController,
                        "DD-MM-YYYY",
                        Icons.calendar_month_outlined,
                      ),
                      const Gap(20),

                      const Text(
                        "Gender",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Gap(8),
                      Obx(
                        () => Row(
                          children: [
                            _buildRadio("Male"),
                            const Gap(20),
                            _buildRadio("Female"),
                          ],
                        ),
                      ),
                      const Gap(20),
                    ],

                    const Text(
                      "Email Address",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    _buildField(
                      authController.emailController,
                      "demo@admin.com",
                      Icons.email_outlined,
                    ),
                    const Gap(20),

                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(8),
                    Obx(
                      () => TextField(
                        controller: authController.passwordController,
                        obscureText: !authController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "••••••••",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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

                    const Gap(25),

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
                              : () {
                                  isLogin
                                      ? authController.loginAdmin()
                                      : authController.registerAdmin();
                                },
                          child: authController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  isLogin ? "Admin Log In" : "Register Admin",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const Gap(20),
                    Center(
                      child: InkWell(
                        onTap: () => setState(() => isLogin = !isLogin),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: isLogin
                                    ? "Don't have an account? "
                                    : "Already have an account? ",
                              ),
                              TextSpan(
                                text: isLogin ? "Sign Up" : "Login Now",
                                style: const TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildRadio(String val) {
    return Row(
      children: [
        Radio<String>(
          value: val,
          groupValue: authController.selectedGender.value,
          activeColor: const Color(0xFF6366F1),
          onChanged: (v) => authController.selectedGender.value = v!,
        ),
        Text(val),
      ],
    );
  }
}

class AdminAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var selectedGender = "Male".obs;
  var isPasswordVisible = false.obs;

  // --- SIGNUP LOGIC ---
  Future<void> registerAdmin() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;
      QuerySnapshot adminCheck = await _db.collection('adminUsers').get();
      bool isFirstAdmin = adminCheck.docs.isEmpty;

      // Data as per your requirements
      await _db.collection('adminUsers').doc(uid).set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "dob": dobController.text.trim(),
        "gender": selectedGender.value,
        "userId": uid,
        "role": isFirstAdmin ? "super_admin" : "admin",
        "status": isFirstAdmin ? "active" : "pending",
        "createdAt": FieldValue.serverTimestamp(),
        "isVerified": "pending",
        "userimage": "",
      });

      Get.snackbar(
        "Success",
        isFirstAdmin
            ? "Super Admin Registered!"
            : "Registration Successful! Wait for approval.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (isFirstAdmin) Get.offAllNamed(AppRoutes.homepro);
    } catch (e) {
      Get.snackbar(
        "Signup Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIN LOGIC ---
  Future<void> loginAdmin() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      DocumentSnapshot adminDoc = await _db
          .collection('adminUsers')
          .doc(userCredential.user!.uid)
          .get();

      if (adminDoc.exists) {
        if (adminDoc['status'] == 'active') {
          Get.offAllNamed(AppRoutes.homepro);
        } else {
          await _auth.signOut();
          Get.snackbar(
            "Pending",
            "Account is not active yet.",
            backgroundColor: Colors.orange,
          );
        }
      } else {
        await _auth.signOut();
        Get.snackbar(
          "Denied",
          "Not an Admin account.",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Login Failed", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}

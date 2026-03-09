// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
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
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  // Sidebar Items as per your requirement
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.grid_view_rounded},
    {'title': 'User Management', 'icon': Icons.people_outline_rounded},
    {'title': 'Verification Request', 'icon': Icons.verified_user_outlined},
    {'title': 'Gifts', 'icon': Icons.card_giftcard_rounded},
    {'title': 'Reactions', 'icon': Icons.emoji_emotions_outlined},
    {'title': 'Currency', 'icon': Icons.monetization_on_outlined},
    {
      'title': 'Withdrawal Request',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {'title': 'Support Request', 'icon': Icons.support_agent_rounded},
    {'title': 'Profile', 'icon': Icons.person_outline_rounded},
    {'title': 'Logout', 'icon': Icons.logout_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF1F2F7,
      ), // Light gray background from screenshot
      body: Row(
        children: [
          // --- SIDEBAR ---
          Container(
            width: 260,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(30),
                // App Logo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flash_on,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      const Gap(12),
                      Text(
                        "Shortie",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(40),
                // Menu List
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF6366F1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _menuItems[index]['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 22,
                              ),
                              const Gap(15),
                              Text(
                                _menuItems[index]['title'],
                                style: GoogleFonts.poppins(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // --- MAIN CONTENT ---
          Expanded(
            child: Column(
              children: [
                // Top Header
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, color: Colors.grey),
                      Row(
                        children: [
                          Text(
                            "Demo Admin",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(12),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE0E7FF),
                            child: Icon(Icons.person, color: Color(0xFF6366F1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Page Display
                Expanded(child: _getPage(_selectedIndex)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const UsersPage();
      case 2:
        return const VerificationPage();
      case 3:
        return const GiftsPage();
      case 6:
        return const WithdrawalPage();
      default:
        return Center(
          child: Text("Page: ${_menuItems[index]['title']} Coming Soon"),
        );
    }
  }
}

// --- DEMO CLASSES (AS REQUESTED) ---

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Admin !",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          // Stats Row (Same as Screenshot)
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.8,
            children: [
              _buildStatCard("Total User", "16", Icons.people, Colors.blue),
              _buildStatCard(
                "Total Active",
                "2",
                Icons.person_pin,
                Colors.purple,
              ),
              _buildStatCard(
                "Total Verified",
                "1",
                Icons.verified,
                Colors.indigo,
              ),
              _buildStatCard("Total Report", "0", Icons.report, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          Icon(icon, color: color.withOpacity(0.7), size: 35),
        ],
      ),
    );
  }
}

// Placeholder Classes
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Users List"));
}

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("Verification Requests"));
}

class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("Gifts Management"));
}

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("Withdrawal Requests"));
}

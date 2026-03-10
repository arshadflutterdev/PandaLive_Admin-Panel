import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/SettingsScreen/settings_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';
import 'package:panda_adminpanel/admin_panel_pro/Coins_Plans/coins_plands.dart';
import 'package:panda_adminpanel/admin_panel_pro/Currency_Screens/currency_screens.dart';
import 'package:panda_adminpanel/admin_panel_pro/DashBoard/dashboard_screen.dart';
import 'package:panda_adminpanel/admin_panel_pro/Gifts/gift_screen.dart';
import 'package:panda_adminpanel/admin_panel_pro/LogoutScreen/logout_screen.dart';
import 'package:panda_adminpanel/admin_panel_pro/Order_History/order_history.dart';
import 'package:panda_adminpanel/admin_panel_pro/ProfileScreen/profile_screen.dart';
import 'package:panda_adminpanel/admin_panel_pro/Reports/reports_screen.dart';
import 'package:panda_adminpanel/admin_panel_pro/Supports/team_support.dart';
import 'package:panda_adminpanel/admin_panel_pro/User_Manage_Screens/all_users.dart';
import 'package:panda_adminpanel/admin_panel_pro/VerifyUsers/verifyusers_pro.dart';
import 'package:panda_adminpanel/admin_panel_pro/Withdrawal_screens/withdrawal_screens.dart';

class HomeScreenPro extends StatefulWidget {
  const HomeScreenPro({super.key});

  @override
  State<HomeScreenPro> createState() => _HomeScreenProState();
}

class _HomeScreenProState extends State<HomeScreenPro> {
  int _selectedIndex = 0;
  bool _isSidebarVisible = true; // Laptop toggle state
  // --- IS LIST KA SEQUENCE CHECK KAREIN ---
  List<Widget> appscreens = [
    DashboardScreen(), // 0
    AppUsersScreen(), // 1
    VerifyusersPro(), // 2
    GiftScreen(), // 3
    Placeholder(), // 4 <-- Yahan Reactions ki screen rakhein (Abhi ke liye Placeholder)
    CurrencyScreens(), // 5
    WithdrawalScreens(), // 6
    CoinsPlans(), // 7
    OrderHistory(), // 8
    SupportAdminScreen(), // 9
    LiveStreamers(), // 10
    SettingsScreen(), // 11
    ProfileScreen(), // 12
    LogoutScreen(), // 13
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

      // Mobile AppBar: Builder use kiya hai taaki context ka masla na ho
      appBar: null,

      // Mobile Drawer
      drawer: isMobile
          ? Drawer(
              width: 280,
              child: _buildSidebarContent(true),
              backgroundColor: Colors.white,
            )
          : null,

      body: Row(
        children: [
          // Laptop Sidebar: Toggle logic
          if (!isMobile && _isSidebarVisible)
            Container(
              width: 280,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: _buildSidebarContent(false),
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(isMobile),
                Expanded(
                  child: IndexedStack(
                    // IndexedStack use karein taaki screen state save rahe
                    index: _selectedIndex,
                    children: appscreens,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(bool isMobile) {
    return Column(
      children: [
        const Gap(40),
        _buildLogo(),
        const Gap(30),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              _sectionTitle("DASHBOARD"),
              _navItem(0, Icons.grid_view_rounded, "Dashboard", isMobile),

              _sectionTitle("USER MANAGEMENT"),
              _navItem(1, Icons.people_outline_rounded, "User", isMobile),
              _navItem(2, Icons.verified, "Verification Request", isMobile),

              _sectionTitle("CONTENT MANAGEMENT"),
              _navItem(3, Icons.wallet_giftcard_sharp, "Gifts", isMobile),
              _navItem(
                4,
                Icons.add_reaction,
                "Reactions",
                isMobile,
              ), // Alag Index (4)

              _sectionTitle("FINANCE"),
              _navItem(
                5,
                Icons.monetization_on_outlined,
                "Currency",
                isMobile,
              ), // Alag Index (5)
              _navItem(
                6,
                Icons.account_balance_wallet_outlined,
                "Withdraw",
                isMobile,
              ), // Alag Index (6)

              _sectionTitle("PACKAGES"),
              _navItem(
                7,
                Icons.currency_exchange_rounded,
                "Coins Plans",
                isMobile,
              ),
              _navItem(8, Icons.history, "Order-History", isMobile),

              _sectionTitle("REPORTS & REQUESTS"),
              _navItem(9, Icons.help, "Support Request", isMobile),
              _navItem(10, Icons.report, "Live Video", isMobile),

              _sectionTitle("GENERAL"),
              _navItem(11, Icons.settings, "Settings", isMobile),
              _navItem(12, Icons.person_2_outlined, "Profile", isMobile),
              _navItem(13, Icons.logout, "Logout", isMobile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _navItem(int index, IconData icon, String label, bool isMobile) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        // Navigator.pop remove kar diya gaya hai (Requirement #2)
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const Gap(15),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Image(image: AssetImage(AppImages.panda), height: 40),
          const Gap(10),
          Text(
            "PandaLive",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[500],
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Row(
          children: [
            if (isMobile)
              // Mobile Menu Icon
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            else
              // Laptop Toggle Icon
              IconButton(
                icon: Icon(
                  _isSidebarVisible ? Icons.menu_open : Icons.menu,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isSidebarVisible = !_isSidebarVisible;
                  });
                },
              ),

            const Gap(15),

            // --- YE HAI AAPKA TITLE ---
            Text(
              "Panda  admin",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const Spacer(),

            // Profile Icon
            const CircleAvatar(
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(Icons.person, color: Color(0xFF2196F3)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTopHeader(bool isMobile) {
  //   return Container(
  //     height: 70,
  //     padding: const EdgeInsets.symmetric(horizontal: 30),
  //     color: Colors.white,
  //     child: Row(
  //       children: [
  //         // Laptop Toggle Button
  //         if (!isMobile)
  //           IconButton(
  //             icon: Icon(
  //               _isSidebarVisible ? Icons.menu_open : Icons.menu,
  //               color: Colors.grey,
  //             ),
  //             onPressed: () {
  //               setState(() {
  //                 _isSidebarVisible = !_isSidebarVisible;
  //               });
  //             },
  //           ),
  //         const Spacer(),
  //         const CircleAvatar(
  //           backgroundColor: Color(0xFFE3F2FD),
  //           child: Icon(Icons.person, color: Color(0xFF6366F1)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_images.dart';

class HomeScreenPro extends StatefulWidget {
  const HomeScreenPro({super.key});

  @override
  State<HomeScreenPro> createState() => _HomeScreenProState();
}

class _HomeScreenProState extends State<HomeScreenPro> {
  int _selectedIndex = 0;
  bool _isSidebarVisible = true; // Laptop toggle state

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

      // Mobile AppBar: Builder use kiya hai taaki context ka masla na ho
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Text(
                "PandaLive Admin",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
              ),
            )
          : null,

      // Mobile Drawer
      drawer: isMobile
          ? Drawer(width: 280, child: _buildSidebarContent(true))
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
                  child: Center(
                    child: Text(
                      "Page: $_selectedIndex",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
              _sectionTitle("Content Management"),
              _navItem(3, Icons.wallet_giftcard_sharp, "Gifts", isMobile),
              _navItem(4, Icons.add_reaction, "Reactions", isMobile),

              _sectionTitle("FINANCE"),
              _navItem(6, Icons.monetization_on_outlined, "Currency", isMobile),
              _navItem(
                7,
                Icons.account_balance_wallet_outlined,
                "Withdraw",
                isMobile,
              ),
              _sectionTitle("Content Management"),
              _navItem(
                8,
                Icons.currency_exchange_rounded,
                "Coins Plans",
                isMobile,
              ),
              _navItem(
                9,
                Icons.account_balance_wallet_outlined,
                "Order-History",
                isMobile,
              ),
              _sectionTitle("Reports & Requests"),
              _navItem(
                10,
                Icons.currency_exchange_rounded,
                "Support Request",
                isMobile,
              ),
              _navItem(
                11,
                Icons.account_balance_wallet_outlined,
                "Report",
                isMobile,
              ),
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
          fontSize: 10,
          color: Colors.grey[500],
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isMobile) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: Colors.white,
      child: Row(
        children: [
          // Laptop Toggle Button
          if (!isMobile)
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
          const Spacer(),
          const CircleAvatar(
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Color(0xFF6366F1)),
          ),
        ],
      ),
    );
  }
}

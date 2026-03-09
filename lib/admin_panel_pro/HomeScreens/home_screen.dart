import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenPro extends StatefulWidget {
  const HomeScreenPro({super.key});

  @override
  State<HomeScreenPro> createState() => _HomeScreenProState();
}

class _HomeScreenProState extends State<HomeScreenPro> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screen width check karne ke liye
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F7), // Background color match
      // Mobile par AppBar aur Drawer dikhega
      appBar: isMobile
          ? AppBar(backgroundColor: Colors.white, elevation: 0.5)
          : null,
      drawer: isMobile ? Drawer(child: _buildSidebarContent()) : null,

      body: Row(
        children: [
          // Desktop par Sidebar hamesha open (Auto Open) rahega
          if (!isMobile)
            Container(
              width: 280,
              color: Colors.white,
              child: _buildSidebarContent(),
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                if (!isMobile) _buildTopHeader(), // Desktop header
                Expanded(
                  child: Center(
                    child: Text("Selected Page Index: $_selectedIndex"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar ka design (Same as your image)
  Widget _buildSidebarContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(30),
        _buildLogo(),
        const Gap(30),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSectionTitle("DASHBOARD"),
                _buildMenuItem(0, Icons.grid_view_rounded, "Dashboard"),
                _buildSectionTitle("USER MANAGEMENT"),
                _buildMenuItem(1, Icons.person_outline_rounded, "User"),
                _buildMenuItem(
                  2,
                  Icons.verified_user_outlined,
                  "Verification Request",
                ),
                _buildSectionTitle("CONTENT MANAGEMENT"),
                _buildMenuItem(3, Icons.image_outlined, "Banner"),
                _buildMenuItem(4, Icons.card_giftcard_rounded, "Gift"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Color(0xFF6366F1), size: 30),
          const Gap(10),
          Text(
            "Shortie",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[400],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      selected: isSelected,
      onTap: () => setState(() => _selectedIndex = index),
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.grey[600]),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 14,
        ),
      ),
      tileColor: Colors.transparent,
      selectedTileColor: const Color(0xFF6366F1), // Purple color match
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Demo Admin", style: TextStyle(fontWeight: FontWeight.bold)),
          Gap(10),
          CircleAvatar(
            backgroundColor: Color(0xFFF1F2F7),
            child: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

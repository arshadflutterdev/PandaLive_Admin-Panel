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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FD),
      // Mobile screen par AppBar aur Drawer icon show hoga
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              title: Text(
                "Shortie Admin",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
              ),
            )
          : null,

      // Mobile ke liye Drawer
      drawer: isMobile
          ? Drawer(width: 280, child: _buildSidebarContent(isMobile))
          : null,

      body: Row(
        children: [
          // Web/Desktop par Sidebar pehle se display hoga
          if (!isMobile)
            Container(
              width: 280,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: _buildSidebarContent(isMobile),
            ),

          // Main Screen Content
          Expanded(
            child: Column(
              children: [
                if (!isMobile) _buildTopHeader(),
                Expanded(child: _buildBodyContent()),
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
              _navItem(
                2,
                Icons.verified_user_outlined,
                "Verification Request",
                isMobile,
              ),

              _sectionTitle("FINANCE"),
              _navItem(6, Icons.monetization_on_outlined, "Currency", isMobile),
              _navItem(
                7,
                Icons.account_balance_wallet_outlined,
                "Withdraw Request",
                isMobile,
              ),

              _sectionTitle("GENERAL"),
              _navItem(10, Icons.settings_outlined, "Setting", isMobile),
              _navItem(11, Icons.person_outline_rounded, "Profile", isMobile),
              _navItem(12, Icons.logout_rounded, "Logout", isMobile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _navItem(int index, IconData icon, String label, bool isMobile) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () {
          setState(() => _selectedIndex = index);
          // Mobile par click hone ke baad drawer hide ho jaye
          if (isMobile) Navigator.pop(context);
        },
        selected: isSelected,
        leading: Icon(
          icon,
          size: 22,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),

        // Selected background color blue
        selectedTileColor: const Color(0xFF2196F3),
        selectedColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Color(0xFF2196F3), size: 28),
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[400],
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: Colors.white,
      child: Row(
        children: [
          // Drawer icon click pe hide/show logic yahan add ho sakti hai (agar desktop toggle chahiye)
          const Icon(Icons.menu_open, color: Colors.grey),
          const Spacer(),
          Text(
            "Demo Admin",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          const Gap(10),
          const CircleAvatar(
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Color(0xFF2196F3)),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dashboard Overview",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          // Demo content for verification of layout
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(child: Text("Welcome to Shortie Admin Panel")),
          ),
        ],
      ),
    );
  }
}

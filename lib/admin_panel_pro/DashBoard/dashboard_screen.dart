import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panda_adminpanel/admin_panel_pro/User_Manage_Screens/all_users.dart';

// Assume AppUsersScreen is imported here

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("userProfile")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          // Data Aggregation
          int totalUsers = docs.length;
          int verifiedUsers = docs
              .where((d) => (d.data() as Map)['isVerified'] == true)
              .length;
          int blockedUsers = docs
              .where((d) => (d.data() as Map)['blockStatus'] == "blocked")
              .length;
          int activeUsers = totalUsers - blockedUsers;

          List<FlSpot> graphSpots = _getGraphData(docs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Gap(30),

                // Fix: Calling the Stats Grid here
                _buildStatsGrid(
                  totalUsers,
                  verifiedUsers,
                  activeUsers,
                  blockedUsers,
                ),

                const Gap(30),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildChartCard(
                        "User Registration Trends",
                        _buildLineChart(graphSpots),
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      flex: 1,
                      child: _buildChartCard(
                        "User Distribution",
                        _buildDonutChart(
                          activeUsers,
                          blockedUsers,
                          verifiedUsers,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Monthly Data Logic
  List<FlSpot> _getGraphData(List<QueryDocumentSnapshot> docs) {
    Map<int, int> monthlyCount = {for (var i = 1; i <= 12; i++) i: 0};
    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['createdAt'] is Timestamp) {
        int month = (data['createdAt'] as Timestamp).toDate().month;
        monthlyCount[month] = (monthlyCount[month] ?? 0) + 1;
      }
    }
    return monthlyCount.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();
  }

  // --- Reusable Navigation Grid ---
  Widget _buildStatsGrid(int total, int verified, int active, int blocked) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _statTile(
          "Total Users",
          total.toString(),
          Icons.people,
          Colors.indigo,
          () {
            Get.to(() => const AppUsersScreen(), arguments: 0);
          },
        ),
        _statTile(
          "Verified",
          verified.toString(),
          Icons.verified,
          Colors.blue,
          () {
            Get.to(() => const AppUsersScreen(), arguments: 1);
          },
        ),
        _statTile("Blocked", blocked.toString(), Icons.block, Colors.red, () {
          Get.to(() => const AppUsersScreen(), arguments: 2);
        }),
        _statTile("Active", active.toString(), Icons.bolt, Colors.green, () {
          Get.to(() => const AppUsersScreen(), arguments: 0);
        }),
      ],
    );
  }

  Widget _statTile(
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const Gap(15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B3674),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Charts Implementation ---
  Widget _buildLineChart(List<FlSpot> spots) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (val) =>
              FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                if (value >= 1 && value <= 12) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[value.toInt() - 1],
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF6C63FF),
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF6C63FF).withOpacity(0.1),
            ),
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(int active, int blocked, int verified) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: [
                PieChartSectionData(
                  value: active.toDouble(),
                  color: Colors.green,
                  title: '$active',
                  radius: 25,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                PieChartSectionData(
                  value: blocked.toDouble(),
                  color: Colors.redAccent,
                  title: '$blocked',
                  radius: 25,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                PieChartSectionData(
                  value: verified.toDouble(),
                  color: Colors.blue,
                  title: '$verified',
                  radius: 25,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(20),
        _buildLegendRow("Active Users", Colors.green),
        _buildLegendRow("Blocked Users", Colors.redAccent),
        _buildLegendRow("Verified Users", Colors.blue),
      ],
    );
  }

  Widget _buildLegendRow(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const Gap(10),
          Text(
            text,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      height: 450,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: const Color(0xFF2B3674),
            ),
          ),
          const Gap(30),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Welcome Admin !",
      style: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2B3674),
      ),
    );
  }
}

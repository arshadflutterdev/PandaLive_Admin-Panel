import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
        backgroundColor: AppColours.bg,
        centerTitle: true,
      ),
      backgroundColor: AppColours.bg,
      body: Container(
        color: Colors.white,
        height: 45,
        child: TabBar(
          controller: tabController,

          indicatorPadding: EdgeInsets.zero,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,

          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: Color(0xff0D1A63),
            borderRadius: BorderRadius.circular(5),
          ),
          tabs: [Text("Request"), Text("Approved"), Text("Rejected")],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Center(child: Text("Wallet")),
    );
  }
}

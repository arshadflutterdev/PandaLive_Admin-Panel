import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Row(
        children: [
          Container(
            width: width * 0.15,
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: DrawerHeader(
                    child: Text(
                      "Panda Admin",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
}

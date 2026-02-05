import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Utils/Constants/app_colours.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.bg,
      body: Center(child: Text('Graph Screen')),
    );
  }
}

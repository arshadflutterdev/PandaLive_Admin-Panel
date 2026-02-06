import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(user["name"])));
  }
}

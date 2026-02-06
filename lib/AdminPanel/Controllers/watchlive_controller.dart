import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WatchStreamControllers extends GetxController {
  RxBool isfollowing = false.obs;
  final String currenduser =
      FirebaseAuth.instance.currentUser?.uid ?? "guest_admin";
  TextEditingController commentController = TextEditingController();

  final arg = Get.arguments;

  Future<void> checkFollowers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(arg["uid"])
        .collection("Followers")
        .doc(currenduser)
        .get();
    isfollowing.value = doc.exists;
  }
  //below are related comments

  RxString commentuser = "Guest".obs;
  Future<void> commentUsers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(currenduser)
        .get();
    if (doc.exists) {
      commentuser.value = doc.data()?["name"] ?? "No Name";
    }
  }

  Future<void> sendComment() async {
    if (commentController.text.isEmpty) return;
    String comment = commentController.text.toString();
    commentController.clear();
    try {
      await FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(arg["uid"])
          .collection("Comments")
          .add({
            "userName": commentuser.value,
            "userId": currenduser,
            "comment": comment,
            "sendAt": FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint("Comment error: $e");
    }
  }
}

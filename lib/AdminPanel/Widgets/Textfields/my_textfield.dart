import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Widget? label;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? hintText;
  final TextEditingController? controller;
  const MyTextField({
    super.key,
    this.hintText,
    this.label,
    this.prefix,
    this.suffix,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefix: prefix,
        label: label,
        hint: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

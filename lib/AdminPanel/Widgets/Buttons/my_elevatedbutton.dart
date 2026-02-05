import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onpressed;
  final Color? bcolor;
  const MyElevatedButton({
    super.key,
    required this.child,
    required this.onpressed,
    this.bcolor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bcolor ?? const Color(0xFF2D5A27),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onpressed,
      child: child,
    );
  }
}

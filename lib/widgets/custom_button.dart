import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;
  final Widget? child; // ✅ Allow custom child

  const CustomButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
    this.child, // ✅ Accept custom child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child:
            child ??
            Text(
              text ?? '',
              style: TextStyle(color: textColor),
            ), // ✅ Use child if available
      ),
    );
  }
}

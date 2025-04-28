import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final bool isPassword;

  const CustomFormField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required TextEditingController controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 4),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 5),
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

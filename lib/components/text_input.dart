import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  int borderColor = 0xFF0000FF;
  bool obscureText;

  TextInput({
    required this.hint,
    required this.onChanged,
    this.borderColor = 0xFF0000FF,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(borderColor),
          ),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
        fillColor: Colors.blue,
      ),
    );
  }
}

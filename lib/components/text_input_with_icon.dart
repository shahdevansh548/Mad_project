import 'package:flutter/material.dart';

class TextInputWithIcon extends StatelessWidget {
  final IconData icon;
  final IconData? suffixIcon;
  final String hint;
  final Function(String) onChanged;
  final Function()? onTapForSuffixIcon;
  final bool ObscureText;

  TextInputWithIcon(
      {required this.icon,
      required this.hint,
      required this.onChanged,
      this.ObscureText = false,
      this.suffixIcon = null,
      this.onTapForSuffixIcon = null});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: ObscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onTapForSuffixIcon,
          child: Icon(
            suffixIcon,
          ),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 20.0,
        ),
        icon: CircleAvatar(
          child: Icon(
            icon,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}

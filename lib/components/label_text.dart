// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String label;

  LabelText({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      ),
    );
  }
}

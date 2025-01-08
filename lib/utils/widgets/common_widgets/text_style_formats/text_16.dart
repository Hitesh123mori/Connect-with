import 'package:flutter/material.dart';

class Text16 extends StatelessWidget {
  final String text;
  final bool? isBold;
  const Text16({super.key, required this.text, this.isBold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (isBold ?? true)
          ? TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          : TextStyle(fontSize: 16),
    );
  }
}

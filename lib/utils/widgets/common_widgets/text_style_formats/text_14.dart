import 'package:flutter/material.dart';

class Text14 extends StatelessWidget {
  final String text;
  final bool? isBold;
  const Text14({super.key, required this.text, this.isBold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (isBold ?? true)
          ? TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )
          : TextStyle(
              fontSize: 14,
            ),
    );
  }
}

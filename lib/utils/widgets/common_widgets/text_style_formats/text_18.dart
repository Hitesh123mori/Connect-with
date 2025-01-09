import 'package:flutter/material.dart';

class Text18 extends StatelessWidget {
  final String text;
  final bool? isBold;
  final bool? isWhite;

  const Text18({
    super.key,
    required this.text,
    this.isBold,
    this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: (isBold ?? true) ? FontWeight.bold : FontWeight.normal,
        color: (isWhite ?? false) ? Colors.white : Colors.black,
      ),
    );
  }
}

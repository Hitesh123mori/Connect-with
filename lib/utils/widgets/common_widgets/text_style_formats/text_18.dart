import 'package:flutter/material.dart' ;


class Text18 extends StatelessWidget {
  final String text;
  final bool? isBold;
  const Text18({super.key, required this.text, this.isBold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (isBold ?? true)
          ? TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      )
          : TextStyle(
        fontSize: 18,
      ),
    );
  }
}

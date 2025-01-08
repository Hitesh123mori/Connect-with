import 'package:flutter/material.dart';


class NormalText extends StatelessWidget {
  final String text;
  const NormalText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text) ;
  }
}

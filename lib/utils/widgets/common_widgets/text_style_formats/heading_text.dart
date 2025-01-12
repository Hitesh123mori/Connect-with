import 'package:flutter/material.dart' ;


class HeadingText extends StatelessWidget {
  final String heading ;
  const HeadingText({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      softWrap: true,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold),
    ) ;
  }
}

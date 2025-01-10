import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  final String name;
  final String url;

  const LinkButton({super.key, required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
          HelperFunctions.launchURL(url);
      },
      child: Text(
        name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue),
      ),
    );
  }
}

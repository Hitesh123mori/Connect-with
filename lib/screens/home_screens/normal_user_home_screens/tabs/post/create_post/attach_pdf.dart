import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart' ;

class AttachPdfScreen extends StatefulWidget {
  const AttachPdfScreen({super.key});

  @override
  State<AttachPdfScreen> createState() => _AttachPdfScreenState();
}

class _AttachPdfScreenState extends State<AttachPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'],
        appBar: AppBar(
          elevation: 1,
          surfaceTintColor: AppColors.theme['primaryColor'],
          title: Text(
            "Attach Document",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.theme['secondaryColor'],
          toolbarHeight: 50,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
              color: Colors.black,
            ),
          ),
        ),

      ),
    );
  }
}

import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'],
        body: Center(
          child: Text("POST SCREEN HERE"),
        ),
      ),
    );
  }
}

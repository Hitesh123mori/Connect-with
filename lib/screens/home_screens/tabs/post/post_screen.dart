import 'package:flutter/material.dart';

import '../../../../utils/theme/colors.dart';

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

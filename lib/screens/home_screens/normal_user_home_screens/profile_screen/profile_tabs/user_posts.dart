import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart' ;

class UserPosts extends StatefulWidget {
  const UserPosts({super.key});

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'],
        body: Container(
          child:Text("No Posts"),
        ),
      ),
    );
  }
}

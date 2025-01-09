import 'package:connect_with/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PostScreenOrganization extends StatefulWidget {
  const PostScreenOrganization({super.key});

  @override
  State<PostScreenOrganization> createState() => _PostScreenOrganizationState();
}

class _PostScreenOrganizationState extends State<PostScreenOrganization> {
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

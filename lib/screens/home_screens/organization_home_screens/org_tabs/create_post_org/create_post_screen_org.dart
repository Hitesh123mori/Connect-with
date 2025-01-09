import 'package:flutter/material.dart';


class CreatePostScreenOrganization extends StatefulWidget {
  const CreatePostScreenOrganization({super.key});

  @override
  State<CreatePostScreenOrganization> createState() => _CreatePostScreenOrganizationState();
}

class _CreatePostScreenOrganizationState extends State<CreatePostScreenOrganization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("CREATE SCREEN HERE"),
        ),
      ),
    );

  }
}

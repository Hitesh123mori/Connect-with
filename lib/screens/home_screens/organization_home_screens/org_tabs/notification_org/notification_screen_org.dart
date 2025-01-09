import 'package:flutter/material.dart' ;

class NotificationScreenOrganization extends StatefulWidget {
  const NotificationScreenOrganization({super.key});

  @override
  State<NotificationScreenOrganization> createState() => _NotificationScreenOrganizationState();
}

class _NotificationScreenOrganizationState extends State<NotificationScreenOrganization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("NOTIFICATION SCREEN HERE"),
        ),
      ),
    );
  }
}

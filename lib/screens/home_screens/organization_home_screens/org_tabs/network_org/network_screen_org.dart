import 'package:flutter/material.dart' ;


class NetWorkScreenOrganization extends StatefulWidget {
  const NetWorkScreenOrganization({super.key});

  @override
  State<NetWorkScreenOrganization> createState() => _NetWorkScreenOrganizationState();
}

class _NetWorkScreenOrganizationState extends State<NetWorkScreenOrganization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("NETWORK SCREEN HERE"),
        ),
      ),
    );
  }
}

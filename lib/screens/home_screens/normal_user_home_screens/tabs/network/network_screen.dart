import 'package:flutter/material.dart' ;


class NetWorkScreen extends StatefulWidget {
  const NetWorkScreen({super.key});

  @override
  State<NetWorkScreen> createState() => _NetWorkScreenState();
}

class _NetWorkScreenState extends State<NetWorkScreen> {
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

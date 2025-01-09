import 'package:flutter/material.dart' ;

class JobScreenOrganization extends StatefulWidget {
  const JobScreenOrganization({super.key});

  @override
  State<JobScreenOrganization> createState() => _JobScreenOrganizationState();
}

class _JobScreenOrganizationState extends State<JobScreenOrganization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("JOB SCREEN HERE"),
        ),
      ),
    );
  }
}

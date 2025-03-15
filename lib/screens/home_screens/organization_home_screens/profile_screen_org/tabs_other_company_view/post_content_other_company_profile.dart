import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';

class PostContentOtherCompanyProfile extends StatefulWidget {
  final Organization org;
  const PostContentOtherCompanyProfile({super.key, required this.org});

  @override
  State<PostContentOtherCompanyProfile> createState() => _PostContentOtherCompanyProfileState();
}

class _PostContentOtherCompanyProfileState extends State<PostContentOtherCompanyProfile> {




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text("Post Content"),

          SizedBox(height: 30,),

        ],
      ),
    );
  }
}

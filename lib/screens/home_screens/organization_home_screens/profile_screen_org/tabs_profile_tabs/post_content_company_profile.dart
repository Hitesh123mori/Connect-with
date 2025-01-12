import 'package:connect_with/providers/organization_provider.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';

class PostContentCompanyProfile extends StatefulWidget {
  const PostContentCompanyProfile({super.key});

  @override
  State<PostContentCompanyProfile> createState() => _PostContentCompanyProfileState();
}

class _PostContentCompanyProfileState extends State<PostContentCompanyProfile> {


  @override
  void initState() {
    super.initState();
    final orgProvider = Provider.of<OrganizationProvider>(context, listen: false);
    orgProvider.initOrganization();
  }

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

import 'package:flutter/material.dart' ;

class PostContentCompanyProfile extends StatefulWidget {
  const PostContentCompanyProfile({super.key});

  @override
  State<PostContentCompanyProfile> createState() => _PostContentCompanyProfileState();
}

class _PostContentCompanyProfileState extends State<PostContentCompanyProfile> {
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

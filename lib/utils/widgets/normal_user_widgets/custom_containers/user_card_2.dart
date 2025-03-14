import 'dart:developer';

import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/screens/home_screens/normal_user_home_screens/profile_screen/other_user_profile_screen.dart';
import 'package:connect_with/side_transitions/left_right.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_14.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:flutter/material.dart';

class UserCard2 extends StatefulWidget {
  final String userID;
  final VoidCallback onTap;

  const UserCard2({
    super.key, required this.userID, required this.onTap,
  });

  @override
  State<UserCard2> createState() => _UserCard2State();
}

class _UserCard2State extends State<UserCard2> {

  AppUser? user ;

  Future<void> fetchUser() async {
    try {
      var userData = await UserProfile.getUser(widget.userID ?? "");
      setState(() {
        user = AppUser.fromJson(userData);
      });
    } catch (e) {
      log("Error while fetching user in user card 2: $e");
    }
  }


  @override
  void initState(){
    super.initState() ;
    fetchUser() ;
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user?.profilePath ?? "")
      ),
      title: Text16(text: user?.userName ?? ""),
      subtitle: Text14(text: user?.headLine ?? "",isBold: false,),
      onTap: widget.onTap,
    );
  }
}
